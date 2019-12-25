import 'package:flutter/foundation.dart';
import 'package:sis_loader/sis_loader.dart';

class CurrentSession extends ChangeNotifier {
  SISLoader _sisLoader;

  SISLoader get sisLoader => _sisLoader;

  void setSisLoader(SISLoader loader) {
    _sisLoader = loader;
    notifyListeners();
  }
}
