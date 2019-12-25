import 'package:intl/intl.dart';

import 'cookie_client.dart';

final shortMonthDateFormat = DateFormat('MMM dd, yyyy hh:mm aa');
final longMonthDateFormat = DateFormat('MMMM dd, yyyy, hh:mm aa');

class Course {
  final CookieClient client;
  final String gradesUrl;
  final String courseName;
  final String periodString;
  final String teacherName;
  final int gradePercent;
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

    Map<String, dynamic> extractRowFields(String row) {
      var fieldsMatches = RegExp(
              r'<TD class="LO_field" style="white-space:normal !important;" data-col="(.*?)">(?:<DIV.*?>)?(.*?)(?:<\/DIV>)?<\/TD>')
          .allMatches(row);

      // ignore: omit_local_variable_types
      Map<String, dynamic> fields = {};

      for (var match in fieldsMatches) {
        var field = match.group(1).toLowerCase();
        dynamic content = match.group(2);

        if (field == 'comment') {
          if (content == '<span class="unreset"></span>') {
            content = null;
          }
        } else if (field == 'assigned_date' || field == 'due_date') {
          if ((content as String).isEmpty) {
            content = null;
          } else {
            content = shortMonthDateFormat.parse(content);
          }
        } else if (field == 'modified_date') {
          if ((content as String).isEmpty) {
            content = null;
          } else {
            content = longMonthDateFormat.parseLoose(content);
          }
        } else if (field == 'assignment_files') {
          if (content == '&nbsp;') {
            content = null;
          }
        }
        fields[field] = content;
      }

      return fields;
    }

    var b = await gradePage.bodyAsString();
    var gradesMatches = RegExp('<TR id="LOy_row.+?"(.*?)<\/TR>').allMatches(b);

    return gradesMatches.map((m) => extractRowFields(m.group(1))).toList();
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
