import 'package:intl/intl.dart';
import 'package:sis_loader/src/mock_data.dart' as mock_data;

import '../sis_loader.dart' show debugMocking;
import 'cookie_client.dart';

final shortMonthDateFormat = DateFormat('MMM dd, yyyy hh:mm aa');
final shortMonthDayDateFormat = DateFormat('EEE, MMM dd, yyyy hh:mm aa');
final longMonthDateFormat = DateFormat('MMMM dd, yyyy, hh:mm aa');
final longMonthDayDateFormat = DateFormat('EEEE, MMM dd, yyyy hh:mm aa');

DateTime _parseDateTimeCascade(String src, [bool performRegexPass = true]) {
  try {
    return shortMonthDateFormat.parseLoose(src);
  } catch (_) {}
  try {
    return longMonthDateFormat.parseLoose(src);
  } catch (_) {}
  try {
    return shortMonthDayDateFormat.parseLoose(src);
  } catch (_) {}
  if (performRegexPass) {
    try {
      return longMonthDayDateFormat.parseLoose(src);
    } catch (_) {}
  } else {
    return longMonthDayDateFormat.parseLoose(src);
  }
  if (performRegexPass) {
    return _parseDateTimeCascade(
      src.replaceAllMapped(RegExp(r'\b(\d{1,2})(?:st|nd|rd|th)\b'), (match) {
        return '${match.group(1)}';
      }),
      false,
    );
  }

  return null;
}

class Course {
  final CookieClient client;
  final String gradesUrl;
  final String courseName;
  final String periodString;
  final String teacherName;
  final dynamic gradePercent;
  final String gradeLetter;

  Future<List<Map<String, dynamic>>> _grades;

  Course(
      {this.client,
      this.gradesUrl,
      this.courseName,
      this.periodString,
      this.teacherName,
      this.gradePercent,
      this.gradeLetter});

  Future<List<Map<String, dynamic>>> getGrades([force = false]) {
    if (debugMocking) {
      return Future.delayed(
        Duration(seconds: 2),
        () => mock_data.GRADES[courseName],
      );
    }

    if (_grades == null || force) {
      _grades = _fetchRawGrades();
      return _grades;
    } else {
      return _grades;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchRawGrades() async {
    var gradePage = await client
        .get(Uri.parse('https://sis.palmbeachschools.org/focus/' + gradesUrl));

    Map<String, dynamic> extractRowFields(
        String row, Map<String, String> headers) {
      var fieldsMatches = RegExp(
              r'<TD class="LO_field" style="white-space:normal !important;" data-col="(.*?)">(?:<DIV.*?>)?(.*?)(?:<\/DIV>)?<\/TD>')
          .allMatches(row);

      // ignore: omit_local_variable_types
      Map<String, dynamic> fields = {};

      for (var match in fieldsMatches) {
        var rawField = match.group(1).toLowerCase();
        var field = headers[rawField];
        dynamic content = match.group(2);

        if (rawField == 'comment') {
          if (content == '<span class="unreset"></span>') {
            content = null;
          }
        } else if (rawField == 'assigned_date' ||
            rawField == 'due_date' ||
            rawField == 'modified_date') {
          if ((content as String).isEmpty) {
            content = null;
          } else {
            content = _parseDateTimeCascade(content);
          }
        } else if (rawField == 'assignment_files') {
          if (content == '&nbsp;') {
            content = null;
          }
        }
        fields[field] = content;
      }

      return fields;
    }

    var b = await gradePage.bodyAsString();

    var headerMatches = RegExp(
            '<TD class="LO_header" data-assoc="(.*?)"><A HREF=\'.*?\'>(.*?)<')
        .allMatches(b);

    // ignore: omit_local_variable_types
    Map<String, String> headers = {};

    for (var match in headerMatches) {
      headers[match.group(1).toLowerCase()] = match.group(2);
    }

    var gradesMatches = RegExp('<TR id="LOy_row.+?"(.*?)<\/TR>').allMatches(b);

    return gradesMatches
        .map((m) => extractRowFields(m.group(1), headers))
        .toList();
  }

  @override
  String toString() {
    return {
      gradesUrl,
      courseName,
      periodString,
      teacherName,
      gradePercent,
      gradeLetter
    }.toString();
  }
}
