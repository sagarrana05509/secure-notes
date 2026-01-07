import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'core/routes/routes_app_go_router.dart';
import 'core/session/session_manager.dart';
import 'core/lifecycle/lifecycle_watcher.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/event/auth_events.dart';
import 'features/notes/presentation/bloc/notes_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(CheckLoginStatus())),
        BlocProvider(create: (_) => NotesBloc()),
      ],
      child: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(
      LifecycleWatcher(() {
        context.read<AuthBloc>().add(LogoutEvent());
      }),
    );

    _router = createGoRouter(context);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        SessionManager.reset(() {
          context.read<AuthBloc>().add(LogoutEvent());
          Fluttertoast.showToast(msg: "Session Expire Need to re-login");
        });
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }
}
