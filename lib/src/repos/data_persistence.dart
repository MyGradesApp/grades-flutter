import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:grade_core/src/models/models.dart';
import 'package:grade_core/src/models/serializers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart' hide serializers;

class DataPersistence {
  final SharedPreferences prefs;
  Map<String, GradeData> _grades;
  List<Course> _courses;
  AcademicInfo _academicInfo;

  static const String ACADEMIC_INFO_KEY = 'persisted_academic_info_v3';
  static const String GRADES_KEY = 'persisted_grades_v3';
  static const String COURSES_KEY = 'persisted_courses_v3';
  static const FullType BUILT_GRADES_TYPE =
      FullType(BuiltMap, [FullType(String), FullType(GradeData)]);
  static const FullType BUILT_COURSES_TYPE =
      FullType(BuiltList, [FullType(Course)]);

  DataPersistence(this.prefs) {
    _grades = _loadGrades();
    _courses = _loadCourses();
    _academicInfo = _loadAcademicInfo();
  }

  Map<String, GradeData> get grades => _grades;

  set grades(Map<String, GradeData> grades) {
    _grades = grades;
    _saveGrades();
  }

  void setGradesForCourse(String course, GradeData grades) {
    (_grades ??= {})[course] = grades;
    _saveGrades();
  }

  AcademicInfo get academicInfo => _academicInfo;

  void setAcademicInfo(AcademicInfo academicInfo) {
    _academicInfo = academicInfo;
    _saveAcademicInfo();
  }

  List<Course> get courses => _courses;

  set courses(List<Course> courses) {
    _courses = courses;
    _saveCourses();
  }

  Map<String, GradeData> _loadGrades() {
    var gradesStr = prefs.getString(DataPersistence.GRADES_KEY);
    if (gradesStr == null || gradesStr.isEmpty || gradesStr == 'null') {
      return null;
    }
    var builtGrades = serializers.deserialize(
      jsonDecode(gradesStr),
      specifiedType: DataPersistence.BUILT_GRADES_TYPE,
    );
    return (builtGrades as BuiltMap<String, GradeData>).toMap();
  }

  void _saveGrades() {
    prefs.setString(
      DataPersistence.GRADES_KEY,
      jsonEncode(serializers.serialize(
        _grades.build(),
        specifiedType: DataPersistence.BUILT_GRADES_TYPE,
      )),
    );
  }

  List<Course> _loadCourses() {
    var coursesString = prefs.getString(DataPersistence.COURSES_KEY);
    if (coursesString == null ||
        coursesString.isEmpty ||
        coursesString == 'null') {
      return null;
    }

    var builtCourses = serializers.deserialize(
      jsonDecode(coursesString),
      specifiedType: DataPersistence.BUILT_COURSES_TYPE,
    ) as BuiltList<Course>;
    return builtCourses.toList();
  }

  void _saveCourses() {
    prefs.setString(
      DataPersistence.COURSES_KEY,
      jsonEncode(serializers.serialize(
        _courses.build(),
        specifiedType: DataPersistence.BUILT_COURSES_TYPE,
      )),
    );
  }

  AcademicInfo _loadAcademicInfo() {
    var academicString = prefs.getString(DataPersistence.ACADEMIC_INFO_KEY);
    if (academicString == null ||
        academicString.isEmpty ||
        academicString == 'null') {
      return null;
    }

    return serializers.deserializeWith(
      AcademicInfo.serializer,
      jsonDecode(academicString),
    );
  }

  void _saveAcademicInfo() {
    prefs.setString(
      DataPersistence.ACADEMIC_INFO_KEY,
      jsonEncode(
        serializers.serializeWith(AcademicInfo.serializer, _academicInfo),
      ),
    );
  }
}
