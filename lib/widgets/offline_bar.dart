import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';

class OfflineBar extends StatelessWidget {
  const OfflineBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(),
      child: Container(
        width: double.infinity,
        color: Colors.orange,
        child: SafeArea(
          top: false,
          child: BlocBuilder<OfflineBloc, OfflineState>(
            builder: (context, state) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('Offline'),
                    ),
                    if (state.loggingIn)
                      Row(
                        children: <Widget>[
                          SizedBox(width: 10),
                          Text('-'),
                          SizedBox(width: 10),
                          Text('Logging in: '),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
