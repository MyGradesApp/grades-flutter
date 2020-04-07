part of 'network_action_bloc.dart';

@immutable
abstract class NetworkActionEvent {
  const NetworkActionEvent();
}

class FetchNetworkData extends NetworkActionEvent {}

class RefreshNetworkData extends NetworkActionEvent {}
