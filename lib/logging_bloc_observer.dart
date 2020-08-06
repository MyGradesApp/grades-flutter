import 'package:bloc/bloc.dart';
import 'package:grade_core/grade_core.dart';

class LoggingBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('Event: $event');
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stacktrace) {
    super.onError(cubit, error, stacktrace);
    print('Exception in ${cubit.runtimeType}');
    reportBlocException(
      exception: error,
      stackTrace: stacktrace,
      tags: {'caught': 'root'},
      bloc: cubit,
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
