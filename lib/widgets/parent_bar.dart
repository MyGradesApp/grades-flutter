import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grade_core/grade_core.dart';

class ParentBar extends StatelessWidget {
  const ParentBar({
    Key key,
  }) : super(key: key);

  static const students = ['Nathan Goldin', 'Lila Goldin', 'Juno Goldin'];

  @override
  Widget build(BuildContext context) {
    var accentColor = const Color(0xff226baa);

    return Material(
      child: DefaultTextStyle(
          style: TextStyle(),
          child: InkWell(
            onTap: () {
              mainBottomSheet(context, accentColor);
            },
            child: Container(
              width: double.infinity,
              color: accentColor,
              child: SafeArea(
                top: false,
                bottom: true,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 6),
                        child: BlocBuilder<ParentBloc, ParentState>(
                            builder: (context, state) {
                          return Text(state.currentStudent,
                              style: TextStyle(fontSize: 16));
                        }),
                      ),
                      students.length > 1
                          ? Icon(
                              FontAwesomeIcons.chevronDown,
                              color: Colors.white,
                              size: 17,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void mainBottomSheet(BuildContext context, Color bg) {
    showModalBottomSheet<BottomSheet>(
        context: context,
        useRootNavigator: true,
        backgroundColor: bg,
        builder: (BuildContext context) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: students.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: Icon(
                  FontAwesomeIcons.solidUser,
                  color: Colors.white,
                ),
                title: Text(
                  students[i],
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () {
                  BlocProvider.of<ParentBloc>(context)
                      .add(SwitchStudentEvent(newStudent: students[i]));
                  print(students[i]);
                  Navigator.pop(context);
                },
              );
            },
          );
        });
  }
}
