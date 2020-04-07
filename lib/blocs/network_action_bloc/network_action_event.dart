part of 'network_action_bloc.dart';

@immutable
abstract class NetworkActionEvent {
  const NetworkActionEvent();
}

class FetchNetworkData extends NetworkActionEvent {
  @override
  String toString() {
    return 'FetchNetworkData{}';
  }
}

class RefreshNetworkData extends NetworkActionEvent {
  @override
  String toString() {
    return 'RefreshNetworkData{}';
  }
}
