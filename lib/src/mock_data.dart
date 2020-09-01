import 'package:sis_loader/sis_loader.dart';
import 'package:sis_loader/src/absences.dart';
import 'package:sis_loader/src/utilities.dart';

final SEMESTERS = {
  'key': 'Semester',
};

final YEARS = {
  '2020': '2020-2021',
};

final COURSES = [
  Course((c) => c
    ..gradesUrl = ''
    ..courseName = 'US HISTORY'
    ..periodString = '01 01'
    ..teacherName = 'Deborah Davis'
    ..gradePercent = StringOrInt(96)
    ..gradeLetter = 'A'),
  Course((c) => c
    ..gradesUrl = ''
    ..courseName = 'ADV PL BIO'
    ..periodString = '04 04'
    ..teacherName = 'Kristopher Mccanns'
    ..gradePercent = StringOrInt(82)
    ..gradeLetter = 'B'),
  Course((c) => c
    ..gradesUrl = ''
    ..courseName = 'ASTRONOMY HONORS'
    ..periodString = '05 05'
    ..teacherName = 'Jessica Lee'
    ..gradePercent = StringOrInt(99)
    ..gradeLetter = 'A'),
  Course((c) => c
    ..gradesUrl = ''
    ..courseName = 'ADV PL US GOV'
    ..periodString = '02 02'
    ..teacherName = 'Daniel Henderson'
    ..gradePercent = StringOrInt(73)
    ..gradeLetter = 'C'),
  Course((c) => c
    ..gradesUrl = ''
    ..courseName = 'AICE ENGLISH LANG'
    ..periodString = '03 03'
    ..teacherName = 'Kimberly Phelps'
    ..gradePercent = StringOrInt(92)
    ..gradeLetter = 'A'),
];

final Map<String, dynamic> RAW_PROFILE = {};

final PROFILE = Profile((p) => p
  ..cumulative_gpa = 3.9
  ..cumulative_weighted_gpa = 4.1
  ..class_rank_numerator = 44
  ..class_rank_denominator = 801);

final Map<String, List<Grade>> GRADES = {
  'US HISTORY': [
    {
      'Assignment': 'Ch. 14 Quiz',
      'Points': '93 / 100',
      'Grade': '93%',
      'Comments': null,
      'Assigned': '2020-01-15 00:00:00',
      'Due': '2020-01-15 00:00:00',
      'Category': 'Quizzes',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-20 19:48:00'
    },
    {
      'Assignment': 'Ch. 14 Quiz',
      'Points': '85 / 100',
      'Grade': '85%',
      'Comments': null,
      'Assigned': '2020-01-15 00:00:00',
      'Due': '2020-01-15 00:00:00',
      'Category': 'Quizzes',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-20 19:48:00'
    },
    {
      'Assignment': 'Ch. 14 Outline',
      'Points': '9 / 8',
      'Grade': '113%',
      'Comments': null,
      'Assigned': '2020-01-14 00:00:00',
      'Due': '2020-01-14 00:00:00',
      'Category': 'Homework/Classwork',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-20 09:21:00'
    },
    {
      'Assignment': 'Class Participation',
      'Points': '4 / 4',
      'Grade': '100%',
      'Comments': null,
      'Assigned': '2020-01-13 00:00:00',
      'Due': '2020-01-16 00:00:00',
      'Category': 'Homework/Classwork',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-20 09:58:00'
    },
    {
      'Assignment': 'Class Participation',
      'Points': '4 / 4',
      'Grade': '100%',
      'Comments': null,
      'Assigned': '2020-01-16 00:00:00',
      'Due': '2020-01-17 00:00:00',
      'Category': 'Homework/Classwork',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-20 09:58:00'
    },
    {
      'Assignment': 'Class Participation',
      'Points': '4 / 4',
      'Grade': '100%',
      'Comments': null,
      'Assigned': '2020-01-15 00:00:00',
      'Due': '2020-01-18 00:00:00',
      'Category': 'Homework/Classwork',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-20 09:58:00'
    },
  ].map((v) => Grade(v)).toList(),
  'ADV PL BIO': [
    {
      'Assignment': 'Genetic Anomalies',
      'Points': '* / 10',
      'Grade': 'Exc.',
      'Comments': null,
      'Assigned': '2020-01-12 00:00:00',
      'Due': '2020-01-12 00:00:00',
      'Category': 'Daily Work',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-15 08:45:00'
    },
    {
      'Assignment': 'Meiosis Worksheet',
      'Points': '30 / 37',
      'Grade': '81%',
      'Comments': null,
      'Assigned': '2020-01-10 00:00:00',
      'Due': '2020-01-11 00:00:00',
      'Category': 'Daily Work',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-13 15:54:00'
    },
    {
      'Assignment': 'Meiosis Drawings',
      'Points': '20 / 20',
      'Grade': '100%',
      'Comments': null,
      'Assigned': '2020-01-10 00:00:00',
      'Due': '2020-01-11 00:00:00',
      'Category': 'Daily Work',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-14 16:15:00'
    },
    {
      'Assignment': 'Meiosis Test',
      'Points': '87 / 100',
      'Grade': '87%',
      'Comments': null,
      'Assigned': '2020-01-07 00:00:00',
      'Due': '2020-01-09 00:00:00',
      'Category': 'Tests',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-09 09:18:00'
    },
    {
      'Assignment': 'Meiosis Quiz',
      'Points': '45 / 50',
      'Grade': '90%',
      'Comments': null,
      'Assigned': '2020-01-07 00:00:00',
      'Due': '2020-01-09 00:00:00',
      'Category': 'Quizzes',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-09 09:18:00'
    },
    {
      'Assignment': 'Meiosis Review',
      'Points': '23 / 23',
      'Grade': '100%',
      'Comments': null,
      'Assigned': '2020-01-07 00:00:00',
      'Due': '2020-01-09 00:00:00',
      'Category': 'Daily Work',
      'Assignment Files': null,
      'Date Last Modified': '2020-01-09 09:18:00'
    },
  ].map((v) => Grade(v)).toList(),
  'ASTRONOMY HONORS': [
    {
      'Assignment': 'Venus Anomalies',
      'Points': '* / 10',
      'Grade': 'Exc.',
      'Comments': null,
      'Assigned': '2020-01-12 00:00:00',
      'Due': '2020-01-12 00:00:00',
      'Category': null,
      'Assignment Files': null,
      'Date Last Modified': '2020-01-15 08:45:00'
    },
    {
      'Assignment': 'Saturn Worksheet',
      'Points': '30 / 37',
      'Grade': '81%',
      'Comments': null,
      'Assigned': '2020-01-10 00:00:00',
      'Due': '2020-01-11 00:00:00',
      'Category': null,
      'Assignment Files': null,
      'Date Last Modified': '2020-01-13 15:54:00'
    },
    {
      'Assignment': 'Jupiter Drawings',
      'Points': '20 / 20',
      'Grade': '100%',
      'Comments': null,
      'Assigned': '2020-01-10 00:00:00',
      'Due': '2020-01-11 00:00:00',
      'Category': null,
      'Assignment Files': null,
      'Date Last Modified': '2020-01-14 16:15:00'
    },
    {
      'Assignment': 'Astronomy Test',
      'Points': '87 / 100',
      'Grade': '87%',
      'Comments': null,
      'Assigned': '2020-01-07 00:00:00',
      'Due': '2020-01-09 00:00:00',
      'Category': null,
      'Assignment Files': null,
      'Date Last Modified': '2020-01-09 09:18:00'
    },
  ].map((v) => Grade(v)).toList(),
  'ADV PL US GOV': [],
  'AICE ENGLISH LANG': [],
};

final Map<String, Map<String, String>> CATEGORY_WEIGHTS = {
  'US HISTORY': {'Tests': '45%', 'Homework/Classwork': '25%', 'Quizzes': '30%'},
  'ADV PL BIO': {'Daily Work': '5%', 'Quizzes': '25%', 'Tests': '40%'},
  'ASTRONOMY HONORS': {},
  'ADV PL US GOV': {'Daily Work': '30%', 'Quizzes': '25%', 'Tests': '40%'},
  'AICE ENGLISH LANG': {},
};

final Absences ABSENCES = Absences((a) => a
  ..days = 2
  ..periods = 3);
final String NAME = 'John Doe';
