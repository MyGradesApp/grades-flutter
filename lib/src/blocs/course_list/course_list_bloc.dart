import 'package:flutter/cupertino.dart';
import 'package:sis_loader/sis_loader.dart';

import '../../repos/sis_repository.dart';
import '../network_action_bloc/network_action_bloc.dart';

class CourseListBloc extends NetworkActionBloc<List<Course>> {
  final SISRepository _sisRepository;

  CourseListBloc({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  Future<List<Course>> fetch() async {
    return await _sisRepository.getCourses();
  }
}
