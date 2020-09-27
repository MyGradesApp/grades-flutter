import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ParentBar extends StatelessWidget {
  const ParentBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var accentColor = const Color(0xff226baa);

    return Material(
      child: DefaultTextStyle(
          style: TextStyle(),
          child: InkWell(
            onTap: () {
              mainBottomSheet(context);
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
                        child:
                            Text('Lila Goldin', style: TextStyle(fontSize: 16)),
                      ),
                      Icon(
                        FontAwesomeIcons.chevronDown,
                        color: Colors.white,
                        size: 17,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void mainBottomSheet(BuildContext context) {
    var kids = ['Nathan Goldin', 'Lila Goldin', 'Juno Goldin'];

    showModalBottomSheet<BottomSheet>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, 'Message', Icons.message, kids[0]),
              _createTile(context, 'Take Photo', Icons.camera_alt, kids[1]),
              _createTile(context, 'My Images', Icons.photo_library, kids[2]),
            ],
          );
        });
  }

  ListTile _createTile(
      BuildContext context, String name, IconData icon, String kid) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        print(kid);
      },
    );
  }
}
