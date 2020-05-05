import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:grade_core/src/sentry.dart';
import 'package:grade_core/src/utilities/consts.dart';
import 'package:grade_core/src/utilities/wrapped_secure_storage.dart';
import 'package:pedantic/pedantic.dart';

import '../../repos/sis_repository.dart';

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
        var secureStorage = WrappedSecureStorage();
        await secureStorage.write(
            key: AuthConst.SIS_USERNAME_KEY, value: event.username);
        await secureStorage.write(
            key: AuthConst.SIS_PASSWORD_KEY, value: event.password);
        await secureStorage.write(
            key: AuthConst.SIS_SESSION_KEY,
            value: _sisRepository.sisLoader.sessionCookies);
        _sisRepository.clearCache();
        yield LoginState.success();
      } catch (e, st) {
        yield LoginState.failure(e, st);
        unawaited(
          reportBlocException(exception: e, stackTrace: st, bloc: this),
        );
      }
    }
  }
}
