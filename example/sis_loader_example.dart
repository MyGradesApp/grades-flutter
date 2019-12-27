import 'dart:io';

import 'package:sis_loader/sis_loader.dart';

Future<void> main() async {
  var username = Platform.environment['username'];
  var password = Platform.environment['password'];
  var loader = SISLoader();

  await loader.login(username, password);
  // Repeated logins work
  await loader.login(username, password);

  print((await loader.getUserProfile()).cumulative_gpa);

  var courses = await loader.getCourses();

  for (var course in courses) {
    var grades = await course.getGrades();
    for (var grade in grades) {
      print(grade);
    }
  }
}
