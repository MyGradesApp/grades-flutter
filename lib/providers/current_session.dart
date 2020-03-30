import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:grades/providers/data_persistence.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class CurrentSession extends ChangeNotifier {
  CachedSISLoader _sisLoader;
  GlobalKey _navKey;
  bool _isOffline = false;
  final DataPersistence _gradePersistence;

  // A unique key to prevent previous sessions from being shown
  GlobalKey get navKey => _navKey;

  CurrentSession({DataPersistence dataPersistence})
      : _gradePersistence = dataPersistence;

  bool get isOffline => _isOffline;

  void setSisLoader(CachedSISLoader loader) {
    _sisLoader = loader;
    _navKey = GlobalKey();
    notifyListeners();
  }

  void setOfflineStatus(bool isOffline) {
    _isOffline = isOffline;
    notifyListeners();
  }

  // TODO: Extract this?
  Future<List<CachedCourse>> courses({bool force = true}) async {
    if (isOffline) {
      return Future.value(_gradePersistence.courses);
    }
    var courses = await _sisLoader.getCourses(force: force);
    _gradePersistence.setCourses(courses);
    return courses;
  }

  Future<AcademicInfo> academicInfo({bool force = true}) async {
    if (isOffline) {
      return null;
    }
    var profile = await _sisLoader.getUserProfile(force: force);
    var absences = await _sisLoader.getAbsences(force: force);

    return AcademicInfo(profile, absences);
  }

  Future<FetchedCourseData> courseData(
      BuildContext context, CachedCourse course,
      {bool force = true, bool offlineOnly = false}) async {
    var grades = await course.getGrades(force: force, offlineOnly: offlineOnly);
    var hasCategories = false;
    if (grades.every((element) => element.raw.containsKey('Category'))) {
      hasCategories = true;
    }
    var weights =
        await course.getCategoryWeights(force: force, offlineOnly: offlineOnly);

    var persistence = Provider.of<DataPersistence>(context, listen: false);
    persistence.insertGrades(course.courseName, grades);
    persistence.markOldAsRead(course.courseName);
    persistence.setWeights(weights);

    return FetchedCourseData(
      grades,
      weights,
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
  final List<Grade> grades;
  final Map<String, String> categoryWeights;
  final bool hasCategories;

  FetchedCourseData(this.grades, this.categoryWeights, this.hasCategories);
}
