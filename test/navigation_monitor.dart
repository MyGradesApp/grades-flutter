import 'package:flutter/widgets.dart';

class NavigationMonitor extends NavigatorObserver {
  bool popped;
  bool pushed;
  bool removed;
  bool replaced;

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    pushed = true;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    popped = true;
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    removed = true;
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    replaced = true;
  }
}
