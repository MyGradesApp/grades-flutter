part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginPressed({@required this.username, @required this.password});

  @override
  List<Object> get props => [username, password];

  @override
  String toString() {
    return 'LoginPressed{username: <..>, password: <..>}';
  }
}
