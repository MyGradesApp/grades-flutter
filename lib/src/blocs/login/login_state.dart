part of 'login_bloc.dart';

@immutable
class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final dynamic error;
  final StackTrace stackTrace;

  const LoginState({
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isFailure,
    this.error,
    this.stackTrace,
  });

  factory LoginState.empty() {
    return LoginState(
      isLoading: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isLoading: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isLoading: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory LoginState.failure(
    dynamic error,
    StackTrace stackTrace,
  ) {
    return LoginState(
      isLoading: false,
      isSuccess: false,
      isFailure: true,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() {
    if (isLoading) {
      return 'LoginState.loading()';
    } else if (isSuccess) {
      return 'LoginState.success()';
    } else if (isFailure) {
      return 'LoginState.failure($error)';
    } else {
      return 'LoginState.empty()';
    }
  }

  LoginState copyWith({
    bool isLoading,
    bool isSuccess,
    bool isFailure,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
