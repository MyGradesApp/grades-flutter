import 'package:grades/models/data_persistence.dart';
import 'package:sis_loader/sis_loader.dart';

class CachedSISLoader {
  final SISLoader _loader;
  final String username;

  CachedSISLoader(this._loader, this.username);

  // Cache
  Future<List<CachedCourse>> _courses;
  Future<Profile> _userProfile;
  Future<Absences> _absences;

  // Wrapping
  String get sessionCookies => _loader.sessionCookies;

  set sessionCookies(String cookies) => _loader.sessionCookies = cookies;

  void login(String username, String password) =>
      _loader.login(username, password);

  // TODO: Pull caching out of sis-loader `Course`s
  Future<List<CachedCourse>> getCourses({bool force = false}) async {
    if (_courses != null && !force) {
      return _courses;
    }
    _courses = _loader.getCourses().then((courses) =>
        courses.map((course) => CachedCourse.fromCourse(course)).toList());
    return _courses;
  }

  Future<Profile> getUserProfile({bool force = false}) async {
    if (_userProfile != null && !force) {
      return _userProfile;
    }
    _userProfile = _loader.getUserProfile();
    return _userProfile;
  }

  Future<Absences> getAbsences({bool force = false}) async {
    if (_absences != null && !force) {
      return _absences;
    }
    _absences = _loader.getAbsences();
    return _absences;
  }
}

// This is a wrapped SISLoader Course type that will soon cache data and implements json serialization
class CachedCourse {
  CookieClient client;
  String gradesUrl;
  String courseName;
  String periodString;
  String teacherName;
  dynamic gradePercent;
  String gradeLetter;
  Course _rawCourse;

  CachedCourse.fromCourse(Course course) {
    _rawCourse = course;
    client = course.client;
    gradesUrl = course.gradesUrl;
    courseName = course.courseName;
    periodString = course.periodString;
    teacherName = course.teacherName;
    gradePercent = course.gradePercent;
    gradeLetter = course.gradeLetter;
  }

  CachedCourse.fromJson(Map<String, dynamic> json) {
    gradesUrl = json["gradeUrl"] as String;
    courseName = json["courseName"] as String;
    periodString = json["periodString"] as String;
    teacherName = json["teacherName"] as String;
    gradePercent = json["gradePercent"];
    gradeLetter = json["gradeLetter"] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["gradeUrl"] = this.gradesUrl;
    data["courseName"] = this.courseName;
    data["periodString"] = this.periodString;
    data["teacherName"] = this.teacherName;
    data["gradePercent"] = this.gradePercent;
    data["gradeLetter"] = this.gradeLetter;
    return data;
  }

  Future<List<Grade>> getGrades([bool force = false]) async {
    if (_rawCourse == null) {
      return Future.value(GLOBAL_DATA_PERSISTENCE.getGrades(courseName));
    }
    return await _rawCourse.getGrades(force);
  }

  Future<Map<String, String>> getCategoryWeights([bool force = false]) async {
    // If we are offline
    if (_rawCourse == null) {
      return Future.value(GLOBAL_DATA_PERSISTENCE.weights);
    }
    var weights = await _rawCourse.getCategoryWeights(force);
    GLOBAL_DATA_PERSISTENCE.setWeights(weights);
    return weights;
  }
}
