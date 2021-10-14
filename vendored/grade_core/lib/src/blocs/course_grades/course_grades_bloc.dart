import 'package:flutter/cupertino.dart';
import 'package:grade_core/grade_core.dart';
import 'package:sis_loader/sis_loader.dart';

import '../network_action_bloc/network_action_bloc.dart';

class CourseGradesBloc extends NetworkActionBloc<GradeData> {
  final SISRepository _sisRepository;
  final Course _course;

  CourseGradesBloc({
    @required SISRepository sisRepository,
    @required Course course,
  })  : assert(sisRepository != null),
        assert(course != null),
        _sisRepository = sisRepository,
        _course = course,
        super(format: (g) => 'grades.length: ${g?.grades?.length}');

  Course get course => _course;

  @override
  Future<GradeData> fetch(bool refresh) async {
    return await _sisRepository.getCourseGrades(_course, refresh: refresh);
  }
}
