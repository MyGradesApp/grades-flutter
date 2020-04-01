import 'dart:async';
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

Future<T> catchFutureHttpError<T>(Future<T> Function() f,
    {void Function() onHttpError}) async {
  try {
    return await f();
  } on HttpException {
    onHttpError?.call();
    return null;
  } on SocketException {
    onHttpError?.call();
    return null;
  } on HandshakeException {
    onHttpError?.call();
    return null;
  } on OSError {
    onHttpError?.call();
    return null;
  } on TimeoutException {
    onHttpError?.call();
    return null;
  }
}

T catchHttpError<T>(T Function() f, {void Function() onHttpError}) {
  try {
    return f();
  } on HttpException {
    onHttpError?.call();
    return null;
  } on SocketException {
    onHttpError?.call();
    return null;
  } on HandshakeException {
    onHttpError?.call();
    return null;
  } on OSError {
    onHttpError?.call();
    return null;
  } on TimeoutException {
    onHttpError?.call();
    return null;
  }
}

bool isHttpError(Object error) {
  return error is SocketException ||
      error is HttpException ||
      error is HandshakeException ||
      error is OSError ||
      error is TimeoutException; // Not really, but this makes things easier
}
