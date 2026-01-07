abstract class AuthRepository {
  Future<bool> login(String user, String pass);
  Future<void> logout();
}
