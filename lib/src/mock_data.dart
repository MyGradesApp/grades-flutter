import 'dart:convert';

import 'package:sis_loader/sis_loader.dart';

final COURSES = [
  Course(
    client: null,
    gradesUrl: '',
    courseName: 'US History',
    periodString: '01 01',
    teacherName: 'Deborah Davis',
    gradePercent: 82,
    gradeLetter: 'B',
  ),
  Course(
    client: null,
    gradesUrl: '',
    courseName: 'AP Bio',
    periodString: '04 04',
    teacherName: 'Kristopher Mccanns',
    gradePercent: 100,
    gradeLetter: 'A',
  ),
  Course(
    client: null,
    gradesUrl: '',
    courseName: 'Astronomy Honors',
    periodString: '05 05',
    teacherName: 'Jessica Lee',
    gradePercent: 99,
    gradeLetter: 'A',
  ),
  Course(
    client: null,
    gradesUrl: '',
    courseName: 'US Gov',
    periodString: '02 02',
    teacherName: 'Daniel Henderson',
    gradePercent: 87,
    gradeLetter: 'B',
  ),
  Course(
    client: null,
    gradesUrl: '',
    courseName: 'English Lang Honors',
    periodString: '03 03',
    teacherName: 'Kimberly Phelps',
    gradePercent: 92,
    gradeLetter: 'A',
  ),
];

final RAW_PROFILE = '{}';

final PROFILE = Profile(
  cumulative_gpa: 3.9,
  cumulative_weighted_gpa: 4.1,
  class_rank_numerator: 44,
  class_rank_denominator: 801,
);

final gradesDump =
    '{"US History":[{"Assignment":"Ch, 14 Quiz","Points":"93 / 100","Grade":"93%","Comments":null,"Assigned":"2020-01-17 00:00:00.000","Due":"2020-01-17 00:00:00.000","Category":"Quizzes","Assignment Files":null,"Date Last Modified":"2020-01-21 19:48:00.000"},{"Assignment":"Ch. 14 Outline","Points":"9 / 8","Grade":"113%","Comments":null,"Assigned":"2020-01-17 00:00:00.000","Due":"2020-01-17 00:00:00.000","Category":"Homework/Classwork","Assignment Files":null,"Date Last Modified":"2020-01-22 09:21:00.000"},{"Assignment":"Class Participation/Spot Checks","Points":"4 / 4","Grade":"100%","Comments":null,"Assigned":"2020-01-17 00:00:00.000","Due":"2020-01-17 00:00:00.000","Category":"Homework/Classwork","Assignment Files":null,"Date Last Modified":"2020-01-20 09:58:00.000"}],"AP Bio":[{"Assignment":"Genetic Anomalies Google Slide","Points":"* / 10","Grade":"Exc.","Comments":null,"Assigned":"2020-01-16 00:00:00.000","Due":"2020-01-16 00:00:00.000","Category":"Daily Work","Assignment Files":null,"Date Last Modified":"2020-01-17 08:45:00.000"},{"Assignment":"Meiosis_Mastering Biology","Points":"30 / 37","Grade":"81%","Comments":null,"Assigned":"2020-01-13 00:00:00.000","Due":"2020-01-14 00:00:00.000","Category":"Daily Work","Assignment Files":null,"Date Last Modified":"2020-01-16 15:54:00.000"},{"Assignment":"Meiosis Drawings","Points":"20 / 20","Grade":"100%","Comments":null,"Assigned":"2020-01-07 00:00:00.000","Due":"2020-01-09 00:00:00.000","Category":"Daily Work","Assignment Files":null,"Date Last Modified":"2020-01-16 16:15:00.000"},{"Assignment":"Meiosis POGIL","Points":"23 / 23","Grade":"100%","Comments":null,"Assigned":"2020-01-07 00:00:00.000","Due":"2020-01-09 00:00:00.000","Category":"Daily Work","Assignment Files":null,"Date Last Modified":"2020-01-09 09:18:00.000"}],"Astronomy Honors":[],"US Gov": [],"English Lang Honors":[{"Assignment":"Genre Project","Points":"NG / 80","Grade":"Not Graded","Comments":null,"Assigned":"2020-01-16 00:00:00.000","Due":"2020-02-03 00:00:00.000","Category":"Projects","Assignment Files":null,"Date Last Modified":null},{"Assignment":"Paper 1 (A) - Letter from Birmingham","Points":"NG / 40","Grade":"Not Graded","Comments":null,"Assigned":"2020-01-21 00:00:00.000","Due":"2020-01-31 00:00:00.000","Category":"Essays","Assignment Files":null,"Date Last Modified":null},{"Assignment":"Binder Check","Points":"10 / 10","Grade":"100%","Comments":null,"Assigned":"2020-01-07 00:00:00.000","Due":"2020-01-17 00:00:00.000","Category":"Homework","Assignment Files":null,"Date Last Modified":"2020-01-22 12:57:00.000"},{"Assignment":"Winter Diagnostic","Points":"37 / 40","Grade":"93%","Comments":null,"Assigned":"2020-01-16 00:00:00.000","Due":"2020-01-16 00:00:00.000","Category":"Exams","Assignment Files":null,"Date Last Modified":"2020-01-16 13:25:00.000"},{"Assignment":"Diction/Imagery/Syntax","Points":"10 / 10","Grade":"100%","Comments":null,"Assigned":"2020-01-13 00:00:00.000","Due":"2020-01-10 00:00:00.000","Category":"Quizzes","Assignment Files":null,"Date Last Modified":"2020-01-15 08:25:00.000"},{"Assignment":"Novel Packet - Curious Incident of the Dog in the Nighttime","Points":"19 / 20","Grade":"95%","Comments":null,"Assigned":"2019-11-01 00:00:00.000","Due":"2019-12-20 00:00:00.000","Category":"Homework","Assignment Files":null,"Date Last Modified":"2020-01-15 08:37:00.000"}]}';

final Map<String, List<Map<String, dynamic>>> GRADES = () {
  var data1 = Map<String, List<dynamic>>.from(jsonDecode(gradesDump));
  var data2 =
      data1.map((k, v) => MapEntry(k, List<Map<String, dynamic>>.from(v)));
  return data2;
}();
