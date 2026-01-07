sealed class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String user, pass;

  LoginEvent(this.user, this.pass);
}

class LogoutEvent extends AuthEvent {}

class BioMetricLoginEvent extends AuthEvent {}

class CheckLoginStatus extends AuthEvent {}