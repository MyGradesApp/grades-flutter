import 'dart:math';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:sis_loader/src/grade.dart';
import 'package:sis_loader/src/mock_data.dart' as mock_data;
import 'package:sis_loader/src/utilities.dart';

import '../sis_loader.dart' show SISLoader, debugMocking;
import 'cookie_client.dart';

part 'course.g.dart';

class CourseService {
  final SISLoader sisLoader;

  CourseService(this.sisLoader);

  Future<String> _gradePage(Course course) async {
    return (await sisLoader.client.get(Uri.parse(
            'https://sis.palmbeachschools.org/focus/' + course.gradesUrl)))
        .bodyAsString();
  }

  Future<List<Grade>> getGrades(Course course) {
    if (debugMocking) {
      return Future.value(mock_data.GRADES[course.courseName]);
    }

    return _fetchGrades(course);
  }

  Future<Map<String, String>> getCategoryWeights(Course course) {
    if (debugMocking) {
      return Future.value(mock_data.CATEGORY_WEIGHTS[course.courseName]);
    }

    return _fetchCategoryWeights(course);
  }

  Future<List<Grade>> _fetchGrades(Course course) async {
    var gradePage = await _gradePage(course);

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

  Future<Map<String, String>> _fetchCategoryWeights(Course course) async {
    var gradePage = await _gradePage(course);

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
}

abstract class Course implements Built<Course, CourseBuilder> {
  String get gradesUrl;

  String get courseName;

  String get periodString;

  String get teacherName;

  StringOrInt get gradePercent;

  String get gradeLetter;

  Course._();

  factory Course([void Function(CourseBuilder) updates]) = _$Course;

  static Serializer<Course> get serializer => _$courseSerializer;
}
