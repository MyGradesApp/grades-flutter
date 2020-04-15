import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:grade_core/grade_core.dart';

part 'network_action_event.dart';
part 'network_action_state.dart';

abstract class NetworkActionBloc<D>
    extends Bloc<NetworkActionEvent, NetworkActionState> {
  final String Function(D) format;

  Future<D> fetch();

  NetworkActionBloc({this.format});

  @override
  NetworkActionState get initialState => NetworkLoading();

  @override
  Stream<NetworkActionState> mapEventToState(
    NetworkActionEvent event,
  ) async* {
    if (event is FetchNetworkData) {
      yield NetworkLoading();
    }
    try {
      var data = await fetch();
      yield NetworkLoaded<D>(data, format: format);
    } catch (e) {
      if (isHttpError(e)) {
        yield NetworkError();
      } else {
        rethrow;
      }
    }
  }
}
