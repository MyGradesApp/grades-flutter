import 'dart:io';

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

Future<T> ignoreFutureHttpError<T>(Future<T> Function() f) async {
  try {
    return await f();
  } on HttpException catch (_) {
    return null;
  } on SocketException catch (_) {
    return null;
  } on HandshakeException catch (_) {
    return null;
  } on OSError catch (_) {
    return null;
  }
}
