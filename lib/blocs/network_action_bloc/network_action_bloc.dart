import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'network_action_event.dart';
part 'network_action_state.dart';

abstract class NetworkActionBloc<D>
    extends Bloc<NetworkActionEvent, NetworkActionState> {
  Future<D> fetch();

  @override
  NetworkActionState get initialState => NetworkLoading();

  @override
  Stream<NetworkActionState> mapEventToState(
    NetworkActionEvent event,
  ) async* {
    if (event is FetchNetworkData) {
      yield NetworkLoading<D>();
      try {
        var data = await fetch();
        yield NetworkLoaded<D>(data);
      } catch (_) {
        yield NetworkError();
      }
    } else if (event is RefreshNetworkData) {
      var data = await fetch();
      yield NetworkLoaded<D>(data);
    }
  }
}
