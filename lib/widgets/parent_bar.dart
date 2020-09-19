import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ParentBar extends StatelessWidget {
  const ParentBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var accentColor = const Color(0xff226baa);

    return DefaultTextStyle(
      style: TextStyle(),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  child: Text('Lila Goldin', style: TextStyle(fontSize: 16)),
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
    );
  }
}
