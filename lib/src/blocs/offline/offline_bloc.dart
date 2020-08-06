import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'offline_event.dart';
part 'offline_state.dart';

class OfflineBloc extends Bloc<OfflineEvent, OfflineState> {
  OfflineBloc() : super(OfflineState(false, false));

  @override
  Stream<OfflineState> mapEventToState(
    OfflineEvent event,
  ) async* {
    if (event is NetworkOfflineEvent) {
      yield state.update(offline: true);
    } else if (event is NetworkOnlineEvent) {
      yield state.update(offline: false, loggingIn: false);
    } else if (event is LoggingInEvent) {
      yield state.update(loggingIn: true);
    } else if (event is StoppedLoggingInEvent) {
      yield state.update(loggingIn: false);
    }
  }
}
