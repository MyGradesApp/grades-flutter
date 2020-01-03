import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showErrorSnackbar(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
    backgroundColor: Colors.red,
  ));
}
