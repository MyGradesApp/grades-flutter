import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:grades/models/grade_persistence.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class CurrentSession extends ChangeNotifier {
  CachedSISLoader _sisLoader;
  GlobalKey _navKey;

  // A unique key to prevent previous sessions from being shown
  GlobalKey get navKey => _navKey;

  void setSisLoader(CachedSISLoader loader) {
    _sisLoader = loader;
    _navKey = GlobalKey();
    notifyListeners();
  }

  // TODO: Extract this?
  Future<List<Course>> courses({bool force = true}) {
    return _sisLoader.getCourses(force: force);
  }

  Future<AcademicInfo> academicInfo({bool force = true}) async {
    var profile = await _sisLoader.getUserProfile(force: force);
    var absences = await _sisLoader.getAbsences(force: force);

    return AcademicInfo(profile, absences);
  }

  Future<FetchedCourseData> fetchCourseData(BuildContext context, Course course,
      {bool force = true}) async {
    var grades = await course.getGrades(force);
    var hasCategories = false;
    if (grades.every((element) => element.containsKey("Category"))) {
      hasCategories = true;
    }
    Provider.of<GradePersistence>(context, listen: false)
        .insert(course.courseName, grades);

    return FetchedCourseData(
      grades,
      await course.getCategoryWeights(force),
      hasCategories,
    );
  }
}

class AcademicInfo {
  final Profile profile;
  final Absences absences;

  const AcademicInfo(this.profile, this.absences);
}

class FetchedCourseData {
  final List<Map<String, dynamic>> grades;
  final Map<String, String> categoryWeights;
  final bool hasCategories;

  FetchedCourseData(this.grades, this.categoryWeights, this.hasCategories);
}
