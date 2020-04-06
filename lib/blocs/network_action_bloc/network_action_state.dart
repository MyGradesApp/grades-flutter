part of 'network_action_bloc.dart';

@immutable
abstract class NetworkActionState extends Equatable {
  const NetworkActionState();

  @override
  List<Object> get props => [];
}

class NetworkLoading<D> extends NetworkActionState {
  const NetworkLoading();
}

class NetworkLoaded<D> extends NetworkActionState {
  final D data;

  const NetworkLoaded(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() {
    return 'NetworkLoaded{data: $data}';
  }
}

class NetworkError extends NetworkActionState {}
