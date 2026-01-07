import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_notes/features/auth/presentation/bloc/state/auth_state.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/notes/presentation/pages/notes_page.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(
      RouteSettings settings,
      BuildContext context,
      ) {
    final authState = context.read<AuthBloc>().state;

    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );

      case AppRoutes.notes:
        if (authState is AuthSuccess) {
          return MaterialPageRoute(
            builder: (_) => NotesPage(),
          );
        }
        if(authState is AuthLogout){
          context.go(AppRoutes.login);
        }
        // 🚫 Prevent login bypass
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
    }
  }
}
