import 'cookie_client.dart';
import 'course.dart';

class SISLoader {
  final CookieClient _client = CookieClient();
  bool _loggedIn = false;

  Future<void> login(String username, String password) async {
    var response = await _client
        .get(Uri.parse('https://sis.palmbeachschools.org/focus/Modules.php'));

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

    var samlResponse = RegExp(
            r'<input name="SAMLResponse" type="hidden" id="SAMLResponse" value="(.*?)"')
        .firstMatch(await authRequest.bodyAsString())
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
      var percent = gradeParts[0].substring(0, gradeParts[0].length - 1);

      return Course(
          gradesUrl: match[1],
          courseName: match[2],
          periodString: match[3],
          teacherName: match[4],
          gradePercent: int.parse(percent),
          gradeLetter: gradeParts[1],
          client: _client);
    }).toList();

    return courses;
  }
}
