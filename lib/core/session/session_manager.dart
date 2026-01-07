import 'dart:async';
import 'package:flutter/material.dart';

class SessionManager {
  static Timer? _timer;

  static void start(VoidCallback onTimeout) {
    _timer?.cancel();
    _timer = Timer(const Duration(minutes: 2), onTimeout);
  }

  static void reset(VoidCallback onTimeout) {
    start(onTimeout);
  }

  static void stop() {
    _timer?.cancel();
  }
}
