part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final bool offline;

  const Authenticated({@required this.offline});

  factory Authenticated.online() {
    return Authenticated(offline: false);
  }

  factory Authenticated.offline() {
    return Authenticated(offline: true);
  }

  @override
  List<Object> get props => [offline];
}

class Unauthenticated extends AuthenticationState {}
