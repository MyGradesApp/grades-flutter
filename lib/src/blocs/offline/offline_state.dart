part of 'offline_bloc.dart';

class OfflineState extends Equatable {
  final bool offline;
  final bool loggingIn;

  const OfflineState(this.offline, this.loggingIn);

  OfflineState update({
    bool offline,
    bool loggingIn,
  }) {
    return OfflineState(
      offline ?? this.offline,
      loggingIn ?? this.loggingIn,
    );
  }

  @override
  List<Object> get props => [offline];
}
