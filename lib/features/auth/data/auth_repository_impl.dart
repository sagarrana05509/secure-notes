import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const _user = 'admin';
  static const _pass = '1234';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<bool> login(String user, String pass) async {
    if (user == _user && pass == _pass) {
      await _storage.write(key: 'is_logged_in', value: 'true');
      return true;
    }
    return false;
  }

  @override
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<bool> loginWithBiometric() async {
    await _storage.write(key: 'isLoggedIn', value: 'true');
    return true;
  }

  Future<bool> isLoggedIn() async {
    return await _storage.read(key: 'is_logged_in') == 'true';
  }
}
