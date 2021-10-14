import 'package:grade_core/grade_core.dart';
import 'package:meta/meta.dart';

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
