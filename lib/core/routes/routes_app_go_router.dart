import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_notes/features/auth/presentation/bloc/state/auth_state.dart';
import 'package:secure_notes/features/splash/splash_view.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/notes/presentation/pages/notes_page.dart';
import '../services/route_refresh_notifier.dart';
import 'app_routes.dart';

GoRouter createGoRouter(BuildContext context) {
  final authBloc = context.read<AuthBloc>();

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: RouterRefreshNotifier(authBloc),

    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;

      final isSplash = location == AppRoutes.splash;
      final isLogin = location == AppRoutes.login;

      if (authState is AuthInitial || authState is AuthLoading) {
        return isSplash ? null : AppRoutes.splash;
      }

      if (authState is AuthSuccess) {
        return (isLogin || isSplash) ? AppRoutes.notes : null;
      }

      if (authState is AuthLogout || authState is AuthFailure) {
        return isLogin ? null : AppRoutes.login;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.notes,
        builder: (_, __) => const NotesPage(),
      ),
    ],
  );
}


