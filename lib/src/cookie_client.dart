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

// This implements just enough functionality to login and fetch grades on sis
// it should be improved for general use (proper cookie handling and redirects, etc)
class CookieClient {
  final HttpClient _client = HttpClient();
  final Map<String, Cookie> _cookies = {};

  Future<HttpClientResponse> get(Uri url) async {
    var location;
    var response = await _client.getUrl(url).then((HttpClientRequest request) {
      // We need to handle redirects ourselves
      request.followRedirects = false;
      request.cookies.addAll(_cookies.values);
      return request.close();
    }).then((HttpClientResponse response) {
      _cookies.addEntries(
          response.cookies.map((cookie) => MapEntry(cookie.name, cookie)));
      location = response.headers['location'];
      return response;
    });

    if ((response.statusCode == 302 || response.statusCode == 303) &&
        location != null) {
      var newLocation = location[0];
      if ((newLocation as String).startsWith('/')) {
        newLocation = url.scheme + '://' + url.host + newLocation;
      }
      var oldCode = response.statusCode;
      response = await get(Uri.parse(newLocation)).catchError((error) async {
        // TODO: Fix this for real
        if (newLocation == 'Modules.php?modname=misc/Portal.php') {
          newLocation =
              'https://sis.palmbeachschools.org/focus/Modules.php?modname=misc/Portal.php';
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

  Future<HttpClientResponse> post(Uri url, Object data) async {
    var location;
    var response = await _client.postUrl(url).then((HttpClientRequest request) {
      // We need to handle redirects ourselves
      request.followRedirects = false;
      request.cookies.addAll(_cookies.values);
      request.headers.add('content-type', 'application/x-www-form-urlencoded');

      request.write(Uri(queryParameters: data).query);
      return request.close();
    }).then((HttpClientResponse response) {
      _cookies.addEntries(
          response.cookies.map((cookie) => MapEntry(cookie.name, cookie)));
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
