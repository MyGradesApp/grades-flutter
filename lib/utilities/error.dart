import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorSnackbar(ScaffoldState scaffoldState, String message) {
  scaffoldState.showSnackBar(SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    ),
    backgroundColor: Colors.red,
  ));
}
