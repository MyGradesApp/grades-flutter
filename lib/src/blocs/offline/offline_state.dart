part of 'offline_bloc.dart';

class OfflineState extends Equatable {
  final bool offline;
  const OfflineState(this.offline);

  @override
  List<Object> get props => [offline];
}
