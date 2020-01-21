import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:grades/sis-cache/sis_loader.dart';

class CurrentSession extends ChangeNotifier {
  CachedSISLoader _sisLoader;
  GlobalKey _navKey;

  CachedSISLoader get sisLoader => _sisLoader;
  // A unique key to prevent previous sessions from being shown
  GlobalKey get navKey => _navKey;

  void setSisLoader(CachedSISLoader loader) {
    _sisLoader = loader;
    _navKey = GlobalKey();
    notifyListeners();
  }
}
