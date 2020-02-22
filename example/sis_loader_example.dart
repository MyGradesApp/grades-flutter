import 'dart:convert';

import 'package:sis_loader/sis_loader.dart';

Future<void> main() async {
//  var username = Platform.environment['username'];
//  var password = Platform.environment['password'];
  var username = "s2558161d";
  var password = "figure51";
  var loader = SISLoader();

  await loader.login(username, password);
  // Repeated logins work
  await loader.login(username, password);

  print((await loader.getUserProfile()).cumulative_gpa);
  print(await loader.getAbsences());

  var courses = await loader.getCourses();

  var o = {};
  for (var course in courses) {
    print('\n\n');
    var grades = await course.getGrades();
    o[course.courseName] = grades;
//    for (var grade in grades) {
//      print(jsonEncode(grade, toEncodable: (value) {
//        if (value is DateTime) {
//          return value.toString();
//        } else {
//          return value;
//        }
//      }));
//    }
  }

  print(jsonEncode(o));
}
