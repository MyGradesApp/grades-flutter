part of 'offline_bloc.dart';

abstract class OfflineEvent extends Equatable {
  const OfflineEvent();

  @override
  List<Object> get props => [];
}

class NetworkOnlineEvent extends OfflineEvent {}

class NetworkOfflineEvent extends OfflineEvent {}
