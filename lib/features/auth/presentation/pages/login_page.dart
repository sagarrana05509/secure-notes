import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_notes/core/routes/app_routes.dart';
import 'package:secure_notes/features/auth/presentation/bloc/event/auth_events.dart';
import 'package:secure_notes/features/auth/presentation/bloc/state/auth_state.dart';
import 'package:secure_notes/utils/widgets/common_button.dart';
import 'package:secure_notes/utils/widgets/common_text_field.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _userCtrl;
  late final TextEditingController _passCtrl;
  final formKey = GlobalKey<FormState>();

  final _userFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _userCtrl = TextEditingController();
    _passCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    _userFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go(AppRoutes.notes);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: const _LoginCard(),
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin(BuildContext context) {
    FocusManager.instance.primaryFocus!.unfocus();
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(_userCtrl.text.trim(), _passCtrl.text.trim()),
      );
    }
  }

  void _onBiometricLogin(BuildContext context) {
    context.read<AuthBloc>().add(BioMetricLoginEvent());
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard();

  @override
  Widget build(BuildContext context) {
    final pageState = context.findAncestorStateOfType<_LoginPageState>()!;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: pageState.formKey,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Secure Notes',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              /// Username
              CommonTextFormField(
                controller: pageState._userCtrl,
                focusNode: pageState._userFocus,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.person_outline,
                labelText: 'Username',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Username';
                  }
                  return null;
                },
                onSubmitted: () =>
                    FocusScope.of(context).requestFocus(pageState._passFocus),
                nextFocus: pageState._passFocus,
              ),

              const SizedBox(height: 16),

              /// Password
              CommonTextFormField(
                controller: pageState._passCtrl,
                focusNode: pageState._passFocus,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
                onSubmitted: () => pageState._onLogin(context),
                prefixIcon: Icons.lock_outline,
                labelText: 'Password',
              ),

              const SizedBox(height: 24),

              /// Login Button
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (p, c) => c is AuthLoading || p is AuthLoading,
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return CommonButton(
                    title: 'Login',
                    isLoading: isLoading,
                    onPressed: () => pageState._onLogin(context),
                  );
                },
              ),

              const SizedBox(height: 16),

              const _DividerOr(),

              const SizedBox(height: 16),

              /// Biometric Login
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (p, c) => c is AuthLoading || p is AuthLoading,
                builder: (context, state) {
                  return CommonButton(
                    title: 'Login with Biometrics',
                    icon: Icons.fingerprint,
                    type: CommonButtonType.outlined,
                    isLoading: state is AuthLoading,
                    onPressed: () => pageState._onBiometricLogin(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DividerOr extends StatelessWidget {
  const _DividerOr();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('OR'),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
