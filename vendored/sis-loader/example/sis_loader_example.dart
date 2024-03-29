import 'dart:io';

import 'package:sis_loader/sis_loader.dart';

Future<void> main() async {
  var username = Platform.environment['username'];
  var password = Platform.environment['password'];
//  var username = 's2558161d';
//  var password = 'figure51';

  var loader = SISLoader(client: CookieClient());

  await loader.login(username, password);
  // Repeated logins work
  await loader.login(username, password);

  print((await loader.getUserProfile()).cumulative_gpa);
  print(await loader.getAbsences());

  var courses = await loader.getCourses();

  var o = {};
  for (var course in courses) {
    var grades = await loader.courseService.getGrades(course);
    print(grades);
    print(serializers.serialize(grades.grades));
    print('\n\n');
    // exit(2);
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

  // var studentInfo = await loader.getStudentInfo();
  //
  // var communityServiceInfo = studentInfo.firstWhere(
  //     (v) => v['title'] == 'Total Number of Community Service Hours');
  // print(communityServiceInfo['value']);
}
