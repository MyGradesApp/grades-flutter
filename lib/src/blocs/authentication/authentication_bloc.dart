import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:grade_core/src/utilities/consts.dart';
import 'package:grade_core/src/utilities/wrapped_secure_storage.dart';
import 'package:pedantic/pedantic.dart';

import '../../errors.dart';
import '../../repos/sis_repository.dart';
import '../blocs.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SISRepository _sisRepository;
  final OfflineBloc _offlineBloc;

  AuthenticationBloc({
    @required SISRepository sisRepository,
    @required OfflineBloc offlineBloc,
  })  : assert(sisRepository != null),
        assert(offlineBloc != null),
        _sisRepository = sisRepository,
        _offlineBloc = offlineBloc;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      var secureStorage = WrappedSecureStorage();
      var username = await secureStorage.read(key: AuthConst.SIS_USERNAME_KEY);
      var password = await secureStorage.read(key: AuthConst.SIS_PASSWORD_KEY);
      var session = await secureStorage.read(key: AuthConst.SIS_SESSION_KEY);
      if (isEmpty(username) || isEmpty(password)) {
        yield Unauthenticated();
      } else {
        try {
          await _sisRepository.login(
            username,
            password,
            session,
          );
          unawaited(secureStorage.write(
              key: AuthConst.SIS_SESSION_KEY,
              value: _sisRepository.sisLoader.sessionCookies));
          yield Authenticated.online();
        } catch (e) {
          if (isHttpError(e)) {
            _offlineBloc.add(NetworkOfflineEvent());
            yield Authenticated.offline();
          } else if (e is NoSuchMethodError) {
            // Try to login again, but without a session
            try {
              await _sisRepository.login(
                username,
                password,
              );
              unawaited(secureStorage.write(
                  key: AuthConst.SIS_SESSION_KEY,
                  value: _sisRepository.sisLoader.sessionCookies));
              yield Authenticated.online();
            } catch (_) {
              yield Unauthenticated();
            }
          } else {
            yield Unauthenticated();
          }
        }
      }
    } else if (event is LoggedIn) {
      yield Authenticated.online();
    } else if (event is LoggedOut) {
      var secureStorage = WrappedSecureStorage();
      await secureStorage.delete(key: AuthConst.SIS_PASSWORD_KEY);
      await secureStorage.delete(key: AuthConst.SIS_SESSION_KEY);
      yield Unauthenticated();
    }
  }
}

bool isEmpty(String value) {
  return value == null || value.isEmpty;
}
