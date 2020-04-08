import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'offline_event.dart';

class OfflineBloc extends Bloc<OfflineEvent, bool> {
  @override
  bool get initialState => false;

  @override
  Stream<bool> mapEventToState(
    OfflineEvent event,
  ) async* {
    if (event is NetworkOfflineEvent) {
      yield true;
    } else if (event is NetworkOnlineEvent) {
      yield false;
    }
  }
}
