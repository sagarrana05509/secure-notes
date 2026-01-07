import 'package:flutter/widgets.dart';

class LifecycleWatcher extends WidgetsBindingObserver {
  final VoidCallback onBackground;

  LifecycleWatcher(this.onBackground);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      onBackground();
    }
  }
}
