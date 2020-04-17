import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'network_action_event.dart';
part 'network_action_state.dart';

abstract class NetworkActionBloc<D>
    extends Bloc<NetworkActionEvent, NetworkActionState> {
  final String Function(D) format;

  Future<D> fetch(bool refresh);

  NetworkActionBloc({this.format});

  @override
  NetworkActionState get initialState => NetworkLoading();

  @override
  Stream<NetworkActionState> mapEventToState(
    NetworkActionEvent event,
  ) async* {
    bool refresh;
    if (event is FetchNetworkData) {
      yield NetworkLoading();
      refresh = false;
    } else if (event is RefreshNetworkData) {
      refresh = true;
    }
    try {
      var data = await fetch(refresh);
      yield NetworkLoaded<D>(data, format: format);
    } catch (e) {
      yield NetworkError(e);
    }
  }
}
