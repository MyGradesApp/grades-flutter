import 'package:flutter_test/flutter_test.dart';
import 'package:grade_core/grade_core.dart';
import 'package:mockito/mockito.dart';
import 'package:sis_loader/sis_loader.dart';

class MockSISRepo extends Mock implements SISRepository {}

var TEST_COURSE = Course((c) => c
  ..gradesUrl = '/foo/bar.php'
  ..courseName = 'US Gov'
  ..periodString = '02 02'
  ..teacherName = 'Daniel Henderson'
  ..gradePercent = StringOrInt(87)
  ..gradeLetter = 'B');

void main() {
  test('null grades', () async {
    var sisRepo = MockSISRepo();
    when(sisRepo.getCourseGrades(any, refresh: anyNamed('refresh')))
        .thenAnswer((realInvocation) {
      return Future.value(null);
    });
    await expectLater(
      fetchCourseGrades(sisRepo, [TEST_COURSE], (_) => true, true),
      emitsInOrder(<FeedEvent>[
        GradesLoaded(course: TEST_COURSE, grades: []),
        DoneLoading(),
      ]),
    );
  });
}
