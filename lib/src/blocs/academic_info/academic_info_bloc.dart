import 'package:meta/meta.dart';

import '../../repos/sis_repository.dart';
import '../network_action_bloc/network_action_bloc.dart';

class AcademicInfoBloc extends NetworkActionBloc<AcademicInfo> {
  final SISRepository _sisRepository;

  AcademicInfoBloc({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  Future<AcademicInfo> fetch(bool refresh) async {
    return await _sisRepository.getAcademicInfo(refresh: refresh);
  }
}
