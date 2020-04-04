import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/offline/offline_bloc.dart';

class OfflineBar extends StatelessWidget {
  const OfflineBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineBloc, OfflineState>(
      builder: (BuildContext context, OfflineState state) {
        return Text('Offline: ${state.offline}');
      },
    );
  }
}
