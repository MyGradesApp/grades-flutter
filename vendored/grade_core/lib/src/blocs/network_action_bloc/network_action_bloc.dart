import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:grade_core/grade_core.dart';
import 'package:pedantic/pedantic.dart';

part 'network_action_event.dart';
part 'network_action_state.dart';

abstract class NetworkActionBloc<D>
    extends Bloc<NetworkActionEvent, NetworkActionState> {
  final String Function(D) format;

  Future<D> fetch(bool refresh);

  NetworkActionBloc({this.format}) : super(NetworkLoading());

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
    } catch (e, st) {
      yield NetworkActionError(e, st);
      unawaited(
        reportBlocException(exception: e, stackTrace: st, bloc: this),
      );
    }
  }
}
