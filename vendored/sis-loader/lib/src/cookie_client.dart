import 'dart:convert';
import 'dart:io';

class _RedirectInfo implements RedirectInfo {
  @override
  final int statusCode;
  @override
  final String method;

  // ignore: annotate_overrides
  final Uri location;

  const _RedirectInfo(this.statusCode, this.method, this.location);
}

extension StringBody on HttpClientResponse {
  Future<String> bodyAsString() async {
    var body = await utf8.decoder.bind(this).toList();
    return body.join();
  }
}

class MyCookie implements Cookie {
  @override
  String domain;

  @override
  DateTime expires;

  @override
  bool httpOnly;

  @override
  int maxAge;

  @override
  String name;

  @override
  String path;

  @override
  bool secure;

  @override
  String value;

  MyCookie(this.name, this.value);
}

// This implements just enough functionality to login and fetch grades on sis
// it should be improved for general use (proper cookie handling and redirects, etc)
class CookieClient {
  final HttpClient _client = HttpClient();
  final Map<String, Cookie> cookies = {};
  final Map<String, String> illegalCookies = {};

  Future<HttpClientResponse> get(Uri url) async {
    List<String> location;
    var response = await _client.getUrl(url).then((HttpClientRequest request) {
      // We need to handle redirects ourselves
      request.followRedirects = false;
      request.cookies.addAll(cookies.values);
      for (var illegalCookieEntry in illegalCookies.entries) {
        request.cookies
            .add(MyCookie(illegalCookieEntry.key, illegalCookieEntry.value));
      }
      return request.close();
    }).then((HttpClientResponse response) {
      var values = response.headers[HttpHeaders.setCookieHeader] ?? [];
      // GraduationRequirments page returns an illegal cookie, strip that
      // Some pages have been seen to return malformed set-cookie headers,
      // so we just ignore those errors
      var newCookies = values
          .map((v) {
            try {
              return Cookie.fromSetCookieValue(v);
            } on FormatException {
              try {
                var cookie = RegExp('^(.+?)=(.+?);').firstMatch(v);
                illegalCookies[cookie.group(1)] = cookie.group(2);
                return null;
              } on NoSuchMethodError {
                return null;
              }
            }
          })
          .where((cookie) => cookie != null)
          .map((cookie) => MapEntry(cookie.name, cookie));

      cookies.addEntries(newCookies);
      location = response.headers['location'];
      return response;
    });

    if ((response.statusCode == 301 ||
            response.statusCode == 302 ||
            response.statusCode == 303) &&
        location != null) {
      var newLocation = location[0];
      if (newLocation.startsWith('/')) {
        newLocation = url.scheme + '://' + url.host + newLocation;
      }
      var oldCode = response.statusCode;
      response = await get(Uri.parse(newLocation)).catchError((error) async {
        // TODO: Fix this for real
        if (newLocation.startsWith('Modules.php?')) {
          newLocation = 'https://sis.palmbeachschools.org/focus/' + newLocation;
          response = await get(Uri.parse(newLocation));
        } else {
          throw error;
        }
        return response;
      });
      response.redirects
          .add(_RedirectInfo(oldCode, 'GET', Uri.parse(newLocation)));
    }

    return response;
  }

  Future<HttpClientResponse> post(Uri url, Object data,
      {Map<String, Object> headers}) async {
    List<String> location;
    var response = await _client.postUrl(url).then((HttpClientRequest request) {
      // We need to handle redirects ourselves
      request.followRedirects = false;
      request.cookies.addAll(cookies.values);
      for (var illegalCookieEntry in illegalCookies.entries) {
        request.cookies
            .add(MyCookie(illegalCookieEntry.key, illegalCookieEntry.value));
      }
      headers?.forEach((name, value) {
        request.headers.add(name, value);
      });

      if (data is String) {
        request.write(data);
      } else {
        request.headers
            .add('content-type', 'application/x-www-form-urlencoded');
        request.write(Uri(queryParameters: data as Map<String, String>).query);
      }
      return request.close();
    }).then((HttpClientResponse response) {
      var values = response.headers[HttpHeaders.setCookieHeader] ?? [];
      // SAML SSO page returns an illegal cookie, strip that
      var newCookies = values
          .map((v) {
            try {
              return Cookie.fromSetCookieValue(v);
            } on FormatException {
              try {
                var cookie = RegExp('^(.+?)=(.+?);').firstMatch(v);
                illegalCookies[cookie.group(1)] = cookie.group(2);
                return null;
              } on NoSuchMethodError {
                return null;
              }
            }
          })
          .where((cookie) => cookie != null)
          .map((cookie) => MapEntry(cookie.name, cookie));

      cookies.addEntries(newCookies);

      location = response.headers['location'];
      return response;
    });

    if ((response.statusCode == 302 || response.statusCode == 303) &&
        location != null) {
      var oldCode = response.statusCode;
      response = await get(Uri.parse(location[0]));
      response.redirects
          .add(_RedirectInfo(oldCode, 'GET', Uri.parse(location[0])));
    }

    return response;
  }
}
