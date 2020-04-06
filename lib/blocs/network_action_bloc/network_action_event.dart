part of 'network_action_bloc.dart';

@immutable
abstract class NetworkActionEvent extends Equatable {
  const NetworkActionEvent();

  @override
  List<Object> get props => [];
}

class FetchNetworkData extends NetworkActionEvent {}

class RefreshNetworkData extends NetworkActionEvent {}
