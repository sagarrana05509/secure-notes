import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription _subscription;

  RouterRefreshNotifier(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((_) {
      notifyListeners(); // 🔥 Triggers GoRouter redirect
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
