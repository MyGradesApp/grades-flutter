import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:grades/repos/sis_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SISRepository _sisRepository;

  LoginBloc({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginPressed) {
      yield LoginState.loading();
      try {
        await _sisRepository.login(event.username, event.password);
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString('sis_username', event.username);
        await prefs.setString('sis_password', event.password);
        yield LoginState.success();
      } catch (e) {
        yield LoginState.failure(e);
      }
    }
  }
}
