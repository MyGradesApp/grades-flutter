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
    ..gradeLetter = 'A'
    ..coursePeriodId = 1),
  Course((c) => c
    ..gradesUrl = ''
    ..courseName = 'ADV PL BIO'
    ..periodString = '04 04'
    ..teacherName = 'Kristopher Mccanns'
    ..gradePercent = StringOrInt(82)
    ..gradeLetter = 'B'
    ..coursePeriodId = 2),
  Course((c) => c
    ..gradesUrl = ''
    ..courseName = 'ASTRONOMY HONORS'
    ..periodString = '05 05'
    ..teacherName = 'Jessica Lee'
    ..gradePercent = StringOrInt(99)
    ..gradeLetter = 'A'
    ..coursePeriodId = 3),
  Course((c) => c
    ..gradesUrl = ''
    ..courseName = 'ADV PL US GOV'
    ..periodString = '02 02'
    ..teacherName = 'Daniel Henderson'
    ..gradePercent = StringOrInt(73)
    ..gradeLetter = 'C'
    ..coursePeriodId = 4),
  Course((c) => c
    ..gradesUrl = ''
    ..courseName = 'AICE ENGLISH LANG'
    ..periodString = '03 03'
    ..teacherName = 'Kimberly Phelps'
    ..gradePercent = StringOrInt(92)
    ..gradeLetter = 'A'
    ..coursePeriodId = 5),
];

final Map<String, dynamic> RAW_PROFILE = {};

final PROFILE = Profile((p) => p
  ..cumulative_gpa = 3.9
  ..cumulative_weighted_gpa = 4.1
  ..class_rank_numerator = 44
  ..class_rank_denominator = 801);

final Map<String, List<Grade>> G = {
  '1': [
    Grade((g) => g
      ..name = 'Ch. 14 Quiz'
      ..pointsEarnedRaw = StringOrNum('93')
      ..pointsPossibleRaw = StringOrNum('100')
      ..rawLetter = 'A'
      ..category = 'Quizzes'
      ..rawAssignedDate = '2020-01-15 00:00:00'
      ..rawDueDate = '2020-01-15 00:00:00'
      ..rawUpdatedAt = '2020-01-20 19:48:00')
  ]
};

final Map<String, List<Grade>> GRADES = {
  'US HISTORY': [
    Grade((g) => g
      ..name = 'Ch. 14 Quiz'
      ..pointsEarnedRaw = StringOrNum('93')
      ..pointsPossibleRaw = StringOrNum('100')
      ..rawLetter = 'A'
      ..category = 'Quizzes'
      ..rawAssignedDate = 'Wed, 15 Jan 2020 12:00 AM'
      ..rawDueDate = 'Wed, 15 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Mon, 20 Jan 2020 07:48 PM'),
    Grade((g) => g
      ..name = 'Ch. 14 Quiz'
      ..pointsEarnedRaw = StringOrNum('85')
      ..pointsPossibleRaw = StringOrNum('100')
      ..rawLetter = 'B'
      ..category = 'Quizzes'
      ..rawAssignedDate = 'Wed, 15 Jan 2020 12:00 AM'
      ..rawDueDate = 'Wed, 15 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Mon, 20 Jan 2020 07:48 PM'),
    Grade((g) => g
      ..name = 'Ch. 14 Outline'
      ..pointsEarnedRaw = StringOrNum('9')
      ..pointsPossibleRaw = StringOrNum('8')
      ..rawLetter = 'A'
      ..category = 'Homework/Classwork'
      ..rawAssignedDate = 'Tue, 14 Jan 2020 12:00 AM'
      ..rawDueDate = 'Tue, 14 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Mon, 20 Jan 2020 09:21 AM'),
    Grade((g) => g
      ..name = 'Class Participation'
      ..pointsEarnedRaw = StringOrNum('4')
      ..pointsPossibleRaw = StringOrNum('4')
      ..rawLetter = 'A'
      ..category = 'Homework/Classwork'
      ..rawAssignedDate = 'Mon, 13 Jan 2020 12:00 AM'
      ..rawDueDate = 'Thu, 16 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Mon, 20 Jan 2020 09:58 AM'),
    Grade((g) => g
      ..name = 'Class Participation'
      ..pointsEarnedRaw = StringOrNum('4')
      ..pointsPossibleRaw = StringOrNum('4')
      ..rawLetter = 'A'
      ..category = 'Homework/Classwork'
      ..rawAssignedDate = 'Thu, 16 Jan 2020 12:00 AM'
      ..rawDueDate = 'Fri, 17 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Mon, 20 Jan 2020 09:58 AM'),
    Grade((g) => g
      ..name = 'Class Participation'
      ..pointsEarnedRaw = StringOrNum('4')
      ..pointsPossibleRaw = StringOrNum('4')
      ..rawLetter = 'A'
      ..category = 'Homework/Classwork'
      ..rawAssignedDate = 'Wed, 15 Jan 2020 12:00 AM'
      ..rawDueDate = 'Sat, 18 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Mon, 20 Jan 2020 09:58 AM'),
  ],
  'ADV PL BIO': [
    Grade((g) => g
      ..name = 'Genetic Anomalies'
      ..pointsEarnedRaw = StringOrNum('*')
      ..pointsPossibleRaw = StringOrNum('10')
      ..rawLetter = 'A'
      ..category = 'Daily Work'
      ..rawAssignedDate = 'Sun, 12 Jan 2020 12:00 AM'
      ..rawDueDate = 'Sun, 12 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Wed, 15 Jan 2020 08:45 AM'),
    Grade((g) => g
      ..name = 'Meiosis Worksheet'
      ..pointsEarnedRaw = StringOrNum('30')
      ..pointsPossibleRaw = StringOrNum('37')
      ..rawLetter = 'B'
      ..category = 'Daily Work'
      ..rawAssignedDate = 'Fri, 10 Jan 2020 12:00 AM'
      ..rawDueDate = 'Sat, 11 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Mon, 13 Jan 2020 03:54 PM'),
    Grade((g) => g
      ..name = 'Meiosis Drawings'
      ..pointsEarnedRaw = StringOrNum('20')
      ..pointsPossibleRaw = StringOrNum('20')
      ..rawLetter = 'A'
      ..category = 'Daily Work'
      ..rawAssignedDate = 'Fri, 10 Jan 2020 12:00 AM'
      ..rawDueDate = 'Sat, 11 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Tue, 14 Jan 2020 04:15 PM'),
    Grade((g) => g
      ..name = 'Meiosis Test'
      ..pointsEarnedRaw = StringOrNum('87')
      ..pointsPossibleRaw = StringOrNum('100')
      ..rawLetter = 'B'
      ..category = 'Tests'
      ..rawAssignedDate = 'Tue, 07 Jan 2020 12:00 AM'
      ..rawDueDate = 'Thu, 09 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Thu, 09 Jan 2020 09:18 AM'),
    Grade((g) => g
      ..name = 'Meiosis Quiz'
      ..pointsEarnedRaw = StringOrNum('45')
      ..pointsPossibleRaw = StringOrNum('50')
      ..rawLetter = 'A'
      ..category = 'Quizzes'
      ..rawAssignedDate = 'Tue, 07 Jan 2020 12:00 AM'
      ..rawDueDate = 'Thu, 09 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Thu, 09 Jan 2020 09:18 AM'),
    Grade((g) => g
      ..name = 'Meiosis Review'
      ..pointsEarnedRaw = StringOrNum('23')
      ..pointsPossibleRaw = StringOrNum('23')
      ..rawLetter = 'A'
      ..category = 'Daily Work'
      ..rawAssignedDate = 'Tue, 07 Jan 2020 12:00 AM'
      ..rawDueDate = 'Thu, 09 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Thu, 09 Jan 2020 09:18 AM'),
  ],
  'ASTRONOMY HONORS': [
    Grade((g) => g
      ..name = 'Venus Anomalies'
      ..pointsEarnedRaw = StringOrNum('*')
      ..pointsPossibleRaw = StringOrNum('10')
      ..rawLetter = 'A'
      ..category = 'None'
      ..rawAssignedDate = 'Sun, 12 Jan 2020 12:00 AM'
      ..rawDueDate = 'Sun, 12 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Wed, 15 Jan 2020 08:45 AM'),
    Grade((g) => g
      ..name = 'Saturn Worksheet'
      ..pointsEarnedRaw = StringOrNum('30')
      ..pointsPossibleRaw = StringOrNum('37')
      ..rawLetter = 'B'
      ..category = 'None'
      ..rawAssignedDate = 'Fri, 10 Jan 2020 12:00 AM'
      ..rawDueDate = 'Sat, 11 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Mon, 13 Jan 2020 03:54 PM'),
    Grade((g) => g
      ..name = 'Jupiter Drawings'
      ..pointsEarnedRaw = StringOrNum('20')
      ..pointsPossibleRaw = StringOrNum('20')
      ..rawLetter = 'A'
      ..category = 'None'
      ..rawAssignedDate = 'Fri, 10 Jan 2020 12:00 AM'
      ..rawDueDate = 'Sat, 11 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Tue, 14 Jan 2020 04:15 PM'),
    Grade((g) => g
      ..name = 'Astronomy Test'
      ..pointsEarnedRaw = StringOrNum('87')
      ..pointsPossibleRaw = StringOrNum('100')
      ..rawLetter = 'B'
      ..category = 'None'
      ..rawAssignedDate = 'Tue, 07 Jan 2020 12:00 AM'
      ..rawDueDate = 'Thu, 09 Jan 2020 12:00 AM'
      ..rawUpdatedAt = 'Thu, 09 Jan 2020 09:18 AM'),
  ],
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
