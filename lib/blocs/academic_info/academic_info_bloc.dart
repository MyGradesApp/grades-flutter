import 'package:flutter/cupertino.dart';
import 'package:grades/blocs/network_action_bloc/network_action_bloc.dart';
import 'package:grades/repos/sis_repository.dart';

class AcademicInfoBloc extends NetworkActionBloc<AcademicInfo> {
  final SISRepository _sisRepository;

  AcademicInfoBloc({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  Future<AcademicInfo> fetch() async {
    return await _sisRepository.getAcademicInfo();
  }
}
