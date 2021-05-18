import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:sentry/sentry.dart';
import 'package:sis_loader/sis_loader.dart';
import 'package:sis_loader/src/absences.dart';
import 'package:sis_loader/src/exceptions.dart';
import 'package:sis_loader/src/mock_data.dart' as mock_data;
import 'package:sis_loader/src/profile.dart';

import 'cookie_client.dart';
import 'course.dart';

bool debugMocking = false;

class SISMeta {
  final Map<String, String> semesters;
  final Map<String, String> years;

  SISMeta({@required this.semesters, @required this.years});

  @override
  String toString() {
    return 'SISMeta{semesters: $semesters, years: $years}';
  }
}

class SISLoader {
  final CookieClient client;
  CourseService _courseService;
  bool _loggedIn = false;
  String requestToken;
  dynamic initialContext;

  SISLoader({@required this.client});

  CourseService get courseService => _courseService ??= CourseService(this);

  String get sessionCookies {
    return json.encode(client.cookies, toEncodable: (value) {
      if (value is Cookie) {
        return value.toString();
      } else {
        return value.toJson();
      }
    });
  }

  set sessionCookies(String cookies) {
    var newCookiesRaw = json.decode(cookies, reviver: (key, value) {
      if (key == null) return value;
      return Cookie.fromSetCookieValue(value as String);
    });

    client.cookies.addAll(Map<String, Cookie>.from(newCookiesRaw as Map));
  }

  // TODO: Errors
  Future<void> login(String username, String password) async {
    if (username == 's2558161d' && password == 'figure51') {
      debugMocking = true;
      _loggedIn = true;
      return null;
    } else {
      debugMocking = false;
    }

    var samlLogin = await client.get(Uri.parse(
        'https://sis.palmbeachschools.org/focus/Modules.php?sso=saml'));

    var samlLoginBody = await samlLogin.bodyAsString();
    var loggedIn = RegExp(r'<title>Portal</title>').hasMatch(samlLoginBody);
    if (loggedIn) {
      initialContext = _extractInitialContexts(samlLoginBody);
      _loggedIn = true;
      return;
    }

    var samlRequestValue =
        RegExp(r'<input type="hidden" name="SAMLRequest" value="(.*?)"')
            .firstMatch(samlLoginBody)
            .group(1);

    var relayState =
        RegExp(r'<input type="hidden" name="RelayState" value="(.*?)"')
            .firstMatch(samlLoginBody)
            .group(1);

    var ssoLogin = await client.post(
      Uri.parse(
          'https://connected.palmbeachschools.org/simplesaml/saml2/idp/SSOService.php'),
      {'SAMLRequest': samlRequestValue, 'RelayState': relayState},
    );

    var ssoLoginBody = await ssoLogin.bodyAsString();
    var authState =
        RegExp(r'<input type="hidden" name="AuthState" value="(.*?)"')
            .firstMatch(ssoLoginBody)
            .group(1);

    var selectSource = await client.get(Uri.https(
      'connected.palmbeachschools.org',
      'simplesaml/module.php/multiauth/selectsource.php/multiauth/selectsource.php',
      {
        'AuthState': authState,
        'src-ZW5ib2FyZHNzby1zcA==': 'Log in using your District Network ID',
      },
    ));

    var samlRequest =
        RegExp(r'<input type="hidden" name="SAMLRequest" value="(.*?)"')
            .firstMatch(await selectSource.bodyAsString())
            .group(1);

    var samlRequestPost = await client.post(
      Uri.parse('https://www.mysdpbc.org/_saml/EN/post.aspx'),
      {'SAMLRequest': samlRequest},
    );

    var samlRequestForm = RegExp(
      r'<input name="__RequestVerificationToken" type="hidden" value="(.*?)".*?<input id="RedirectUrl" name="RedirectUrl" type="hidden" value="(.*?)"',
    ).firstMatch(await samlRequestPost.bodyAsString());
    var samlRequestVerificationToken = samlRequestForm.group(1);
    var samlRequestVerificationTokenUrl = samlRequestForm.group(2);

    var authRequest =
        await client.post(Uri.parse('https://www.mysdpbc.org/_authn/'), {
      '__RequestVerificationToken': samlRequestVerificationToken,
      'RedirectUrl': samlRequestVerificationTokenUrl,
      'Username': username,
      'Password': password,
      'AuthenticationBadgeToken': '',
    });

    var authResponse = await authRequest.bodyAsString();
    var samlResponseMatch = RegExp(
      r'<input name="SAMLResponse" type="hidden" id="SAMLResponse" value="(.*?)"',
    ).firstMatch(authResponse);

    var enboardRequest = await client.post(
      Uri.parse(
          'https://connected.palmbeachschools.org/simplesaml/module.php/saml/sp/saml2-acs.php/enboardsso-sp'),
      {'SAMLResponse': samlResponseMatch.group(1)},
    );

    var enboardBody = await enboardRequest.bodyAsString();
    var samlResponse2 =
        RegExp(r'<input type="hidden" name="SAMLResponse" value="(.*?)"')
            .firstMatch(enboardBody)
            .group(1);

    var finalRequest = await client.post(
      Uri.parse(
          'https://sis.palmbeachschools.org/focus/sso/saml2/acs.php?id=saml'),
      {'SAMLResponse': samlResponse2, 'RelayState': relayState},
    );

    var finalRequestBody = await finalRequest.bodyAsString();
    requestToken = RegExp(r'__Module__\.token = "(.*?)"')
        .firstMatch(finalRequestBody)
        .group(1);
    initialContext = _extractInitialContexts(finalRequestBody);

    _loggedIn = true;
  }

  dynamic _extractInitialContexts(String body) {
    var contextMatch = RegExp(r'''const {
					methods,
					initial_contexts,
					request_options,
				} = ({.*});''').firstMatch(body).group(1);

    return jsonDecode(contextMatch)['initial_contexts'];
  }

  Future<void> setTerm(String year, String semesterKey) async {
    await client.post(
      Uri.parse(
        'https://sis.palmbeachschools.org/focus/Modules.php?modname=misc/Portal.php',
      ),
      {'side_syear': year, 'side_mp': semesterKey},
    );
  }

  Future<List<Course>> getCourses() async {
    assert(_loggedIn);

    if (debugMocking) {
      return Future.value(mock_data.COURSES);
    }

    var portal = await client
        .get(Uri.parse('https://sis.palmbeachschools.org/focus/Modules.php'));

    initialContext = _extractInitialContexts(await portal.bodyAsString());

    Map<String, dynamic> mps;
    try {
      if (initialContext['PortalController'] == null) {
        await Sentry.captureMessage('Initial context keys: ' +
            Map<String, dynamic>.from(initialContext as Map).keys.toString());
      } else if (initialContext['PortalController']['data'] == null) {
        await Sentry.captureMessage('PortalController keys: ' +
            Map<String, dynamic>.from(initialContext['PortalController'] as Map)
                .keys
                .toString());
      } else if (initialContext['PortalController']['data']['enrollments'] ==
          null) {
        await Sentry.captureMessage('data keys: ' +
            Map<String, dynamic>.from(
                    initialContext['PortalController']['data'] as Map)
                .keys
                .toString());
      }
      mps = Map<String, dynamic>.from(
        initialContext['PortalController']['data']['enrollments'][0]['grades']
            ['mps'][0] as Map,
      );
    } on RangeError {
      return [];
    }

    var rawCourses = initialContext['PortalController']['data']['enrollments']
        [0]['grades']['rows'] as List<dynamic>;
    var courses = (rawCourses).map((grade) {
      var gradeString = grade[mps['mp_grade']] as String;
      String letter;
      StringOrInt percent;
      var letterMatch = RegExp(r'([A-z]+)').firstMatch(gradeString);
      var percentMatch = RegExp(r'([0-9]+)%').firstMatch(gradeString);
      if (letterMatch != null) {
        letter = letterMatch.group(1);
      }
      if (percentMatch != null) {
        // parse will always succeed because the regex matches only digits
        percent = StringOrInt(int.parse(percentMatch.group(1)));
      }

      if (percentMatch == null && letter != null) {
        percent = StringOrInt(letter);
        letter = null;
      }

      return Course((c) {
        return c
          ..gradesUrl = grade[mps['mp_grade_href']] as String
          ..courseName = grade['course_name'] as String
          ..periodString = grade['period_name'] as String
          ..teacherName = grade['teacher_name'] as String
          ..gradePercent = percent
          ..gradeLetter = letter;
      });
    });

    return Future.value(courses.toList());
  }

  Future<Map<String, dynamic>> getRawUserProfile() async {
    assert(_loggedIn);

    if (debugMocking) {
      return Future.value(mock_data.RAW_PROFILE);
    }

    var graduationReqsRequest = await client.get(Uri.parse(
        'https://sis.palmbeachschools.org/focus/Modules.php?modname=GraduationRequirements/GraduationRequirements.php&student_id=new&top_deleted_student=true'));

    String bearerTokenCookie;
    try {
      bearerTokenCookie = (graduationReqsRequest.headers['set-cookie'] ?? [])
          .firstWhere((c) => c.startsWith('Module::'));
    } on StateError {
      throw UnknownMissingCookieException('No module cookie present');
    }
    assert(bearerTokenCookie != null);

    var startIndex = bearerTokenCookie.indexOf('=') + 1;
    var endIndex = bearerTokenCookie.indexOf(';');
    var bearerToken =
        Uri.decodeFull(bearerTokenCookie.substring(startIndex, endIndex));

    var graduationReqsBody = await graduationReqsRequest.bodyAsString();

    var requestToken = RegExp(r'__Module__\.token = "(.*?)"')
        .firstMatch(graduationReqsBody)
        .group(1);

    var studentId =
        RegExp(r'student_id":(.*?),').firstMatch(graduationReqsBody).group(1);

    var today = DateTime.now();
    var todaysDate = '${today.month}/${today.day}/${today.year}';
    var requestData =
        '{"requests":[{"controller":"GraduationRequirementsReportController","method":"getOneStudentReportData","args":[[[{"ID":1,"TITLE":"Main","TEMPLATE":"main_category","CLASS_NAME":"MainCategoryGraduationRequirementsReport","CREATED_BY_CLASS":null,"CREATED_BY_ID":null,"CREATED_AT":null,"UPDATED_BY_CLASS":null,"UPDATED_BY_ID":null,"UPDATED_AT":null}],$studentId,"COURSE_HISTORY","$todaysDate",""]],"session":null}],"cache":{}}';
    var dataRequest = await client.post(
        Uri.parse(
            'https://sis.palmbeachschools.org/focus/classes/FocusModule.class.php?force_package=SIS&modname=GraduationRequirements%2FGraduationRequirements.php&type=SISStudent&id=' +
                studentId),
        '--FormBoundary\r\nContent-Disposition: form-data; name="__call__"\r\n\r\n$requestData\r\n--FormBoundary\r\nContent-Disposition: form-data; name="__token__"\r\n\r\n$requestToken\r\n--FormBoundary--',
        headers: {
          'authorization': 'Bearer ' + bearerToken,
          'content-type': 'multipart/form-data; boundary=FormBoundary',
        });

    return json.decode(await dataRequest.bodyAsString())[0]['result']
        as Map<String, dynamic>;
  }

  Future<Profile> getUserProfile() async {
    if (debugMocking) {
      return Future.value(mock_data.PROFILE);
    }
    var rawProfile = (await getRawUserProfile())['Top'] as Map<String, dynamic>;

    if (rawProfile == null) {
      return Profile();
    }

    var classRankPieces = (rawProfile['class_rank'] as String)?.split(' / ');
    int classRankNumerator;
    int classRankDenominator;
    if (classRankPieces != null && classRankPieces.length == 2) {
      if (classRankPieces[0].trim().isNotEmpty &&
          classRankPieces[1].trim().isNotEmpty) {
        classRankNumerator = int.tryParse(classRankPieces[0]);
        classRankDenominator = int.tryParse(classRankPieces[1]);
      }
    }
    return Profile((p) => p
      ..cumulative_gpa = rawProfile['cumluative_gpa'] != null
          ? double.tryParse(rawProfile['cumluative_gpa'] as String)
          : null
      ..cumulative_weighted_gpa = rawProfile['cumulative_weighted_gpa'] != null
          ? double.tryParse(rawProfile['cumulative_weighted_gpa'] as String)
          : null
      ..class_rank_numerator = classRankNumerator
      ..class_rank_denominator = classRankDenominator);
  }

  Future<List<dynamic>> getStudentInfo() async {
    assert(_loggedIn);

    var studentInfoReq = await client.get(Uri.parse(
        'https://sis.palmbeachschools.org/focus/Modules.php?modname=Students/Student.php'));

    String bearerTokenCookie;
    try {
      bearerTokenCookie = studentInfoReq.headers['set-cookie']
          .firstWhere((c) => c.startsWith('Module::'));
    } on StateError {
      throw UnknownMissingCookieException('No module cookie present');
    }
    assert(bearerTokenCookie != null);

    var startIndex = bearerTokenCookie.indexOf('=') + 1;
    var endIndex = bearerTokenCookie.indexOf(';');
    var bearerToken = bearerTokenCookie.substring(startIndex, endIndex);

    var graduationReqsBody = await studentInfoReq.bodyAsString();

    var requestToken = RegExp(r'__Module__\.token = "(.*?)"')
        .firstMatch(graduationReqsBody)
        .group(1);

    var studentId =
        RegExp(r'student_id":"(.*?)",').firstMatch(graduationReqsBody).group(1);

    var requestData =
        '{"requests":[{"controller":"EditController","method":"cache:getFieldData","args":["10","SISStudent",$studentId],"session":null}],"cache":{}}';
    var dataRequest = await client.post(
        Uri.parse(
            'https://sis.palmbeachschools.org/focus/classes/FocusModule.class.php?modname=Students%2FStudent.php'),
        '--FormBoundary\r\nContent-Disposition: form-data; name="__call__"\r\n\r\n$requestData\r\n--FormBoundary\r\nContent-Disposition: form-data; name="__token__"\r\n\r\n$requestToken\r\n--FormBoundary--',
        headers: {
          'authorization': 'Bearer ' + bearerToken,
          'content-type': 'multipart/form-data; boundary=FormBoundary',
        });

    return json.decode(await dataRequest.bodyAsString())[0]['result'] as List;
  }

  Future<String> getName() async {
    if (debugMocking) {
      return Future.value(mock_data.NAME);
    }

    var nameRequest = await client.get(Uri.parse(
        'https://sis.palmbeachschools.org/focus/Modules.php?modname=misc/Portal.php'));

    var nameBody = await nameRequest.bodyAsString();
    var nameMatch = RegExp(r'Welcome, (.+?)<\/').firstMatch(nameBody);
    if (nameMatch == null) {
      return null;
    }
    return nameMatch.group(1);
  }

  Future<Absences> getAbsences() async {
    if (debugMocking) {
      return Future.value(mock_data.ABSENCES);
    }

    var absencesRequest = await client.get(Uri.parse(
        'https://sis.palmbeachschools.org/focus/Modules.php?force_package=SIS&modname=Attendance/StudentSummary.php'));
    var absencesBody = await absencesRequest.bodyAsString();
    var absencesMatch =
        RegExp(r'<b>Absent:</b> (\d+) periods \(during (\d+) days\)')
            .firstMatch(absencesBody);
    if (absencesMatch == null) {
      return null;
    }
    var absentPeriods = absencesMatch.group(1);
    var absentDays = absencesMatch.group(2);
    return Absences((a) => a
      ..periods = int.tryParse(absentPeriods)
      ..days = int.tryParse(absentDays));
  }
}
