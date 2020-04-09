import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'offline_event.dart';
part 'offline_state.dart';

class OfflineBloc extends Bloc<OfflineEvent, OfflineState> {
  @override
  OfflineState get initialState => OfflineState(false, false);

  @override
  Stream<OfflineState> mapEventToState(
    OfflineEvent event,
  ) async* {
    if (event is NetworkOfflineEvent) {
      yield state.update(offline: true);
    } else if (event is NetworkOnlineEvent) {
      yield state.update(offline: false);
    }
  }
}
