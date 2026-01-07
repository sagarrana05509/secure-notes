import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secure_notes/features/auth/presentation/bloc/state/auth_state.dart';
import '../../../../core/services/bio_metric_service.dart';
import '../../data/auth_repository_impl.dart';
import 'event/auth_events.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl repo = AuthRepositoryImpl();
  final biometricService = BiometricService();

  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatus>((event, emit) async {
      final loggedIn = await repo.isLoggedIn();
      emit(loggedIn ? AuthSuccess() : AuthFailure());
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final success = await repo.login(event.user, event.pass);
      if (!success) {
        Fluttertoast.showToast(msg: 'Invalid credentials');
      }
      emit(success ? AuthSuccess() : AuthFailure());
    });
    on<BioMetricLoginEvent>((event, emit) async {
      emit(AuthLoading());
      final canAuthenticate = await biometricService.authenticate();
      if (canAuthenticate) {
        final success = await repo.loginWithBiometric();

        emit(success ? AuthSuccess() : AuthFailure());
      } else {
        Fluttertoast.showToast(msg: "Biometric authentication failed");
        emit(AuthFailure());
      }
    });

    on<LogoutEvent>((event, emit) async {
      await repo.logout();
      emit(AuthLogout());
    });
  }
}
