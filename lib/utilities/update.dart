import 'dart:convert';
import 'dart:io';

import 'package:grade_core/grade_core.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> launchAppstorePage() {
  return launch('https://apps.apple.com/us/app/swiftgrade/id1495113299');
}

Future<bool> checkUpdateAvailable() async {
  HttpClientResponse resp;
  try {
    resp = await HttpClient()
        .getUrl(Uri.parse(
            'http://itunes.apple.com/lookup?bundleId=com.goldinguy.grades'))
        .then((request) => request.close());
  } catch (_) {
    return false;
  }

  var body = await utf8.decoder.bind(resp).toList();
  var dataStr = body.join();

  dynamic results = (jsonDecode(dataStr))['results'];
  if (results != null && results is List && results.isNotEmpty) {
    dynamic version = results[0]['version'];
    if (version == null || version is! String) {
      return false;
    }

    if (_compareVersions(GRADES_VERSION, version as String) ==
        PartialOrdering.Greater) {
      return true;
    }
  }

  return false;
}

enum PartialOrdering {
  Greater,
  Equal,
  Less,
  Err,
}

PartialOrdering _compareVersions(String current, String other) {
  var cSplit = RegExp(r'(\d+)(?:\+.*)?')
      .allMatches(current)
      .map((match) => match.group(1))
      .toList();
  var oSplit = RegExp(r'(\d+)(?:\+.*)?')
      .allMatches(other)
      .map((match) => match.group(1))
      .toList();

  if (cSplit.length != oSplit.length) {
    return PartialOrdering.Err;
  }
  try {
    for (var i = 0; i < cSplit.length; i += 1) {
      var parsedCurrentPart = int.parse(cSplit[i]);
      var parsedOtherPart = int.parse(oSplit[i]);
      if (parsedCurrentPart < parsedOtherPart) {
        return PartialOrdering.Greater;
      } else if (parsedCurrentPart > parsedOtherPart) {
        return PartialOrdering.Less;
      }
    }
  } catch (e) {
    return PartialOrdering.Err;
  }
  return PartialOrdering.Equal;
}
