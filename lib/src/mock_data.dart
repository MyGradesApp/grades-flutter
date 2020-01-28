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

final Map<String, List<Map<String, dynamic>>> GRADES = {
  'US History': [
    {
      'Assignment': 'Ch. 14 Quiz',
      'Points': '93 / 100',
      'Grade': '93%',
      'Comments': null,
      'Assigned': DateTime.parse('2020-01-15'),
      'Due': DateTime.parse('2020-01-15 00:00:00.000'),
      'Category': 'Quizzes',
      'Assignment Files': null,
      'Date Last Modified': DateTime.parse('2020-01-20 19:48:00.000')
    },
    {
      'Assignment': 'Ch. 14 Outline',
      'Points': '9 / 8',
      'Grade': '113%',
      'Comments': null,
      'Assigned': DateTime.parse('2020-01-14 00:00:00.000'),
      'Due': DateTime.parse('2020-01-14 00:00:00.000'),
      'Category': 'Homework/Classwork',
      'Assignment Files': null,
      'Date Last Modified': DateTime.parse('2020-01-20 09:21:00.000')
    },
    {
      'Assignment': 'Class Participation',
      'Points': '4 / 4',
      'Grade': '100%',
      'Comments': null,
      'Assigned': DateTime.parse('2020-01-13 00:00:00.000'),
      'Due': DateTime.parse('2020-01-13 00:00:00.000'),
      'Category': 'Homework/Classwork',
      'Assignment Files': null,
      'Date Last Modified': DateTime.parse('2020-01-20 09:58:00.000')
    },
  ],
  'AP Bio': [
    {
      'Assignment': 'Genetic Anomalies',
      'Points': '* / 10',
      'Grade': 'Exc.',
      'Comments': null,
      'Assigned': DateTime.parse('2020-01-12 00:00:00.000'),
      'Due': DateTime.parse('2020-01-12 00:00:00.000'),
      'Category': 'Daily Work',
      'Assignment Files': null,
      'Date Last Modified': DateTime.parse('2020-01-15 08:45:00.000')
    },
    {
      'Assignment': 'Meiosis Worksheet',
      'Points': '30 / 37',
      'Grade': '81%',
      'Comments': null,
      'Assigned': DateTime.parse('2020-01-10 00:00:00.000'),
      'Due': DateTime.parse('2020-01-11 00:00:00.000'),
      'Category': 'Daily Work',
      'Assignment Files': null,
      'Date Last Modified': DateTime.parse('2020-01-13 15:54:00.000')
    },
    {
      'Assignment': 'Meiosis Drawings',
      'Points': '20 / 20',
      'Grade': '100%',
      'Comments': null,
      'Assigned': DateTime.parse('2020-01-10 00:00:00.000'),
      'Due': DateTime.parse('2020-01-11 00:00:00.000'),
      'Category': 'Daily Work',
      'Assignment Files': null,
      'Date Last Modified': DateTime.parse('2020-01-14 16:15:00.000')
    },
    {
      'Assignment': 'Meiosis Review',
      'Points': '23 / 23',
      'Grade': '100%',
      'Comments': null,
      'Assigned': DateTime.parse('2020-01-07 00:00:00.000'),
      'Due': DateTime.parse('2020-01-09 00:00:00.000'),
      'Category': 'Daily Work',
      'Assignment Files': null,
      'Date Last Modified': DateTime.parse('2020-01-09 09:18:00.000')
    },
  ],
  'Astronomy Honors': [],
  'US Gov': [],
  'English Lang Honors': [],
};
