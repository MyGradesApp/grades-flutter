// Add support for macos for development
import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WrappedSecureStorage {
  const WrappedSecureStorage();

  Future<void> write({@required String key, @required String value}) async {
    if (Platform.isMacOS) {
      var _prefs = await SharedPreferences.getInstance();
      return await _prefs.setString(key, value).then((_) {
        return;
      });
    } else {
      return await const FlutterSecureStorage().write(key: key, value: value);
    }
  }

  Future<String> read({@required String key}) async {
    if (Platform.isMacOS) {
      var _prefs = await SharedPreferences.getInstance();
      return _prefs.getString(key);
    } else {
      return await const FlutterSecureStorage().read(key: key);
    }
  }

  Future<void> delete({@required String key}) async {
    if (Platform.isMacOS) {
      var _prefs = await SharedPreferences.getInstance();
      return _prefs.remove(key);
    } else {
      return await const FlutterSecureStorage().delete(key: key);
    }
  }
}
