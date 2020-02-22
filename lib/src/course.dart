import 'dart:math';

import 'package:intl/intl.dart';
import 'package:sis_loader/src/grade.dart';
import 'package:sis_loader/src/mock_data.dart' as mock_data;

import '../sis_loader.dart' show debugMocking;
import 'cookie_client.dart';

final shortMonthDateFormat = DateFormat('MMM dd, yyyy hh:mm aa');
final shortMonthDayDateFormat = DateFormat('EEE, MMM dd, yyyy hh:mm aa');
final longMonthDateFormat = DateFormat('MMMM dd, yyyy, hh:mm aa');
final longMonthDayDateFormat = DateFormat('EEEE, MMM dd, yyyy hh:mm aa');
final shortDayTerseDateTimeFormat = DateFormat('EEE, MM/dd/yy hh:mm aa');

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
  try {
    return shortDayTerseDateTimeFormat.parseLoose(src);
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

  Future<String> _gradePageFuture;
  Future<List<Grade>> _grades;
  Future<Map<String, String>> _categoryWeights;

  Course(
      {this.client,
      this.gradesUrl,
      this.courseName,
      this.periodString,
      this.teacherName,
      this.gradePercent,
      this.gradeLetter});

  Future<String> _gradePage({bool force = false}) async {
    if (_gradePageFuture == null || force) {
      _gradePageFuture = (await client.get(
              Uri.parse('https://sis.palmbeachschools.org/focus/' + gradesUrl)))
          .bodyAsString();
      return _gradePageFuture;
    } else {
      return _gradePageFuture;
    }
  }

  Future<List<Grade>> getGrades([bool force = false]) {
    if (debugMocking) {
      return Future.delayed(
        Duration(seconds: 2),
        () => mock_data.GRADES[courseName],
      );
    }

    if (_grades == null || force) {
      _grades = _fetchGrades();
      return _grades;
    } else {
      return _grades;
    }
  }

  Future<Map<String, String>> getCategoryWeights([bool force = false]) {
    if (debugMocking) {
      return Future.delayed(
        Duration(seconds: 2),
        () => mock_data.CATEGORY_WEIGHTS[courseName],
      );
    }

    if (_categoryWeights == null || force) {
      _categoryWeights = _fetchCategoryWeights(force: force);
      return _categoryWeights;
    } else {
      return _categoryWeights;
    }
  }

  Future<List<Grade>> _fetchGrades() async {
    var gradePage = await _gradePage(force: true);

    Map<String, String> extractRowFields(
        String row, Map<String, String> headers) {
      var fieldsMatches = RegExp(
              r'<TD class="LO_field" style="white-space:normal !important;" data-col="(.*?)">(?:<DIV.*?>)?(.*?)(?:<\/DIV>)?<\/TD>')
          .allMatches(row);

      // ignore: omit_local_variable_types
      Map<String, String> fields = {};

      for (var match in fieldsMatches) {
        var rawField = match.group(1).toLowerCase();
        var field = headers[rawField];
        var content = match.group(2);

        if (rawField == 'comment') {
          if (content == '<span class="unreset"></span>') {
            content = null;
          }
        } else if (rawField == 'assigned_date' ||
            rawField == 'due_date' ||
            rawField == 'modified_date') {
          if (content.isEmpty) {
            content = null;
          }
        } else if (rawField == 'assignment_files') {
          if (content == '&nbsp;') {
            content = null;
          } else {
            var match = RegExp(
                    r'<UL><LI style="margin:5px 0px;"><A class="previewIframe" href="javascript:void(0)" data-href="(.*?)">(.*?)<\/A><\/LI><\/UL>')
                .firstMatch(content);
            if (match != null) {
              content = match.group(2);
            } else {
              content = content.replaceAll(RegExp(r'<[^>]*>'), '');
            }
          }
        }
        fields[field] = content;
      }

      return fields;
    }

    var headerMatches = RegExp(
            '<TD class="LO_header" data-assoc="(.*?)"><A HREF=\'.*?\'>(.*?)<')
        .allMatches(gradePage);

    // ignore: omit_local_variable_types
    Map<String, String> headers = {};

    for (var match in headerMatches) {
      headers[match.group(1).toLowerCase()] = match.group(2);
    }

    var gradesMatches =
        RegExp('<TR id="LOy_row.+?"(.*?)<\/TR>').allMatches(gradePage);

    return gradesMatches
        .map((m) => Grade(extractRowFields(m.group(1), headers)))
        .toList();
  }

  Future<Map<String, String>> _fetchCategoryWeights(
      {bool force = false}) async {
    var gradePage = await _gradePage(force: force);

    var weightsTableMatch = RegExp(
            r'<TABLE width=100% border=0 cellpadding=0 cellspacing=0 class="DarkGradientBG'
            r' BottomButton"><TR><TD class="DarkGradientBG BottomButton" align=left>'
            r'<font color=#000000><B><TABLE border=0 cellpadding=4 cellspacing=0>(.*?)<\/TABLE><\/B>')
        .firstMatch(gradePage);
    if (weightsTableMatch == null) {
      return null;
    }
    var weightsTable = weightsTableMatch.group(1);

    var tableRowsMatches = RegExp(r'<TR>(.*?)<\/TR>').allMatches(weightsTable);

    var tableRows = tableRowsMatches
        .map((m) => RegExp(
                r'<(?:TD|TH)(?: .*?)?>(?:<[bB]>)?(.*?)(?:<\/[bB]>)?<\/(?:TD|TH)>')
            .allMatches(m.group(1))
            .map((m) => m.group(1).replaceAll('&nbsp;', ''))
            .toList())
        .toList();

    // Ensure the data matches the known format
    if (!(tableRows.length > 2 &&
        tableRows[0][0] == '' &&
        tableRows[1][0] == 'Percent of Grade')) {
      return null;
    }

    // ignore: omit_local_variable_types
    Map<String, String> out = {};
    for (var i = 1; i < min(tableRows[0].length, tableRows[1].length); i++) {
      if (tableRows[0][i].trim().isEmpty && tableRows[1][i].trim().isEmpty) {
        continue;
      }
      out[tableRows[0][i]] = tableRows[1][i];
    }
    return out;
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
