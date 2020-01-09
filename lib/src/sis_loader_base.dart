import 'dart:convert';
import 'dart:io';

import 'package:sis_loader/sis_loader.dart';
import 'package:sis_loader/src/exceptions.dart';
import 'package:sis_loader/src/profile.dart';

import 'cookie_client.dart';
import 'course.dart';

class SISLoader {
  final CookieClient _client = CookieClient();
  bool _loggedIn = false;

  String get sessionCookies {
    return json.encode(_client.cookies, toEncodable: (value) {
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
      return Cookie.fromSetCookieValue(value);
    });

    _client.cookies.addAll(Map<String, Cookie>.from(newCookiesRaw));
  }

  Future<void> login(String username, String password) async {
    var response = await _client
        .get(Uri.parse('https://sis.palmbeachschools.org/focus/Modules.php'));
    if (response.statusCode == 200 && response.redirects.isEmpty) {
      _loggedIn = true;
      return;
    }

    var body = await response.bodyAsString();
    var authState =
        RegExp(r'<input type="hidden" name="AuthState" value="(.*?)"')
            .firstMatch(body)
            .group(1);
    var startAuthForm =
        RegExp(r'<input .*? type="submit" name="(.*?)" id=".*?" value="(.*?)">')
            .firstMatch(body);
    var startAuthSubmitName = startAuthForm.group(1);
    var startAuthSubmitValue = startAuthForm.group(2);

    var startAuthUrl = Uri.https(
        'connected.palmbeachschools.org',
        'simplesaml/module.php/multiauth/selectsource.php/multiauth/selectsource.php?',
        {'AuthState': authState, startAuthSubmitName: startAuthSubmitValue});
    var startAuth = await _client.get(startAuthUrl);

    var samlRequest =
        RegExp(r'<input type="hidden" name="SAMLRequest" value="(.*?)"')
            .firstMatch(await startAuth.bodyAsString())
            .group(1);

    var samlRequestPost = await _client.post(
        Uri.parse('https://www.mysdpbc.org/_saml/EN/post.aspx'),
        {'SAMLRequest': samlRequest});

    var samlRequestForm = RegExp(
            r'<input name="__RequestVerificationToken" type="hidden" value="(.*?)".*?<input id="RedirectUrl" name="RedirectUrl" type="hidden" value="(.*?)"')
        .firstMatch(await samlRequestPost.bodyAsString());
    var samlRequestVerificationToken = samlRequestForm.group(1);
    var samlRequestVerificationTokenUrl = samlRequestForm.group(2);

    var authRequest =
        await _client.post(Uri.parse('https://www.mysdpbc.org/_authn/'), {
      '__RequestVerificationToken': samlRequestVerificationToken,
      'RedirectUrl': samlRequestVerificationTokenUrl,
      'Username': username,
      'Password': password,
      'AuthenticationBadgeToken': '',
    });

    var authResponse = await authRequest.bodyAsString();
    // Check if it succeeded (failure gives 200 code)
    var authError = RegExp(
            '<span class="field-validation-error text-danger" data-valmsg-for="ErrorMessage" data-valmsg-replace="true">(.*?)</span>')
        .firstMatch(authResponse);

    if (authError != null) {
      throw InvalidAuthException(authError.group(1));
    }

    var samlResponse = RegExp(
            r'<input name="SAMLResponse" type="hidden" id="SAMLResponse" value="(.*?)"')
        .firstMatch(authResponse)
        .group(1);

    var enboardRequest = await _client.post(
        Uri.parse(
            'https://connected.palmbeachschools.org/simplesaml/module.php/saml/sp/saml2-acs.php/enboardsso-sp'),
        {'SAMLResponse': samlResponse});

    var samlResponse2 =
        RegExp(r'<input type="hidden" name="SAMLResponse" value="(.*?)"')
            .firstMatch(await enboardRequest.bodyAsString())
            .group(1);

    await _client.post(
        Uri.parse(
            'https://sis.palmbeachschools.org/focus/simplesaml/module.php/saml/sp/saml2-acs.php/default-sp'),
        {
          'SAMLResponse': samlResponse2,
          'RelayState': 'https://sis.palmbeachschools.org/focus/'
        });

    _loggedIn = true;
  }

  Future<List<Course>> getCourses() async {
    assert(_loggedIn);

    var portalResponse = await _client.get(Uri.parse(
        'https://sis.palmbeachschools.org/focus/Modules.php?modname=misc/Portal.php'));
    var coursesTable = RegExp(
            r'''<\/tr><td style='display:none'>Z<\/td><TD valign=middle><img src="modules\/Grades\/Grades\.png" border=0><\/td><td>([\s\S]*?)<\/table>''')
        .firstMatch(await portalResponse.bodyAsString())
        .group(1);

    var coursesMatches = RegExp(
            r"a href='(.*?)'><b>(.*?)<\/b><\/a><\/td><td nowrap>(.*?)<\/td><td>(.*?)<\/td><td><td><\/td><td nowrap>\s*<a class='grade' href='.*?'>(.*?)<\/a>")
        .allMatches(coursesTable);

    var courses = coursesMatches.map((match) {
      var gradeParts = match[5].split('&nbsp;');
      dynamic percent;
      // TODO: Make more general
      if (gradeParts[0] != 'Not Graded') {
        percent =
            int.tryParse(gradeParts[0].substring(0, gradeParts[0].length - 1));
      } else {
        percent = gradeParts[0];
      }

      return Course(
          gradesUrl: match[1],
          courseName: match[2],
          periodString: match[3],
          teacherName: match[4],
          gradePercent: percent ?? gradeParts[0],
          gradeLetter: gradeParts.length > 1 ? gradeParts[1] : null,
          client: _client);
    }).toList();

    return courses;
  }

  Future<dynamic> getRawUserProfile() async {
    assert(_loggedIn);

    var graduationReqsRequest = await _client.get(Uri.parse(
        'https://sis.palmbeachschools.org/focus/Modules.php?modname=GraduationRequirements/GraduationRequirements.php&student_id=new&top_deleted_student=true'));

    var bearerTokenCookie = graduationReqsRequest.headers['set-cookie']
        .firstWhere((c) => c.startsWith('Module::'));
    assert(bearerTokenCookie != null);

    var startIndex = bearerTokenCookie.indexOf('=') + 1;
    var endIndex = bearerTokenCookie.indexOf(';');
    var bearerToken = bearerTokenCookie.substring(startIndex, endIndex);

    var graduationReqsBody = await graduationReqsRequest.bodyAsString();

    var requestToken = RegExp(r'request_token   = "(.*?)"')
        .firstMatch(graduationReqsBody)
        .group(1);

    var studentId =
        RegExp(r'student_id":(.*?),').firstMatch(graduationReqsBody).group(1);

    var today = DateTime.now();
    var todaysDate = '${today.month}/${today.day}/${today.year}';
    var requestData =
        '{"requests":[{"controller":"GraduationRequirementsReportController","method":"getOneStudentReportData","args":[[[{"ID":1,"TITLE":"Main","TEMPLATE":"main_category","CLASS_NAME":"MainCategoryGraduationRequirementsReport","CREATED_BY_CLASS":null,"CREATED_BY_ID":null,"CREATED_AT":null,"UPDATED_BY_CLASS":null,"UPDATED_BY_ID":null,"UPDATED_AT":null}],$studentId,"COURSE_HISTORY","$todaysDate",""]],"session":null}],"cache":{}}';
    var dataRequest = await _client.post(
        Uri.parse(
            'https://sis.palmbeachschools.org/focus/classes/FocusModule.class.php?modname=GraduationRequirements%2FGraduationRequirements.php&student_id=new&top_deleted_student=true&type=SISStudent&id=' +
                studentId),
        '--FormBoundary\r\nContent-Disposition: form-data; name="__call__"\r\n\r\n$requestData\r\n--FormBoundary\r\nContent-Disposition: form-data; name="__token__"\r\n\r\n$requestToken\r\n--FormBoundary--',
        headers: {
          'authorization': 'Bearer ' + bearerToken,
          'content-type': 'multipart/form-data; boundary=FormBoundary',
        });

    return json.decode(await dataRequest.bodyAsString())[0]['result'];
  }

  Future<Profile> getUserProfile() async {
    var rawProfile = (await getRawUserProfile())['Top'];

    List<String> classRankPieces = rawProfile['class_rank']?.split(' / ');
    return Profile(
        cumulative_gpa: rawProfile['cumluative_gpa'] != null
            ? double.parse(rawProfile['cumluative_gpa'])
            : null,
        cumulative_weighted_gpa: rawProfile['cumulative_weighted_gpa'] != null
            ? double.parse(rawProfile['cumulative_weighted_gpa'])
            : null,
        class_rank_numerator:
            classRankPieces != null ? int.parse(classRankPieces[0]) : null,
        class_rank_denominator:
            classRankPieces != null ? int.parse(classRankPieces[1]) : null);
  }
}
