import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:grades/models/data_persistence.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class CurrentSession extends ChangeNotifier {
  CachedSISLoader _sisLoader;
  GlobalKey _navKey;
  bool _isOffline = false;
  DataPersistence _gradePersistence;

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
  Future<List<CachedCourse>> courses({bool force = true}) {
    if (isOffline) {
      return Future.value(_gradePersistence.courses);
    }
    return _sisLoader.getCourses(force: force);
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
      {bool force = true}) async {
    var grades = await course.getGrades(force);
    var hasCategories = false;
    if (grades.every((element) => element.raw.containsKey('Category'))) {
      hasCategories = true;
    }
    var persistence = Provider.of<DataPersistence>(context, listen: false);
    persistence.insertGrades(course.courseName, grades);
    persistence.markOldAsRead(course.courseName);

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
  final List<Grade> grades;
  final Map<String, String> categoryWeights;
  final bool hasCategories;

  FetchedCourseData(this.grades, this.categoryWeights, this.hasCategories);
}
