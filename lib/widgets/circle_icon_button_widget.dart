import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final double size;
  final void Function() onPressed;
  final IconData icon;

  CircleIconButton({this.size = 19.0, this.icon = Icons.clear, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: const Alignment(0.0, 0.0), // all centered
          children: <Widget>[
            Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff6b87ae)),
            ),
            Icon(
              icon,
              size: size * 0.6, // 60% width for icon
            )
          ],
        ),
      ),
    );
  }
}
