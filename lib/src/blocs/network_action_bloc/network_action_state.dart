part of 'network_action_bloc.dart';

@immutable
abstract class NetworkActionState {
  const NetworkActionState();
}

class NetworkLoading extends NetworkActionState {
  const NetworkLoading();

  @override
  String toString() {
    return 'NetworkLoading{}';
  }
}

class NetworkLoaded<D> extends NetworkActionState {
  final String Function(D) format;
  final D data;

  const NetworkLoaded(this.data, {this.format});

  @override
  String toString() {
    if (format != null) {
      return 'NetworkLoaded{${format(data)}}';
    } else {
      return 'NetworkLoaded{data: $data}';
    }
  }
}

class NetworkError extends NetworkActionState {
  final dynamic error;

  NetworkError(this.error);

  @override
  String toString() {
    return 'NetworkError{error: $error}';
  }
}
