import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  // ⚠️ MUST NEVER CHANGE after release
  static final Key _key = Key.fromUtf8(
    'iBLFinanaceSagarSecureNotesDemo1', // EXACTLY 32 chars
  );

  static final IV _iv = IV.fromUtf8(
    'secureNotesDemo1', // EXACTLY 16 chars
  );

  static final Encrypter _encrypter = Encrypter(
    AES(
      _key,
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ),
  );

  static String encryptText(String plainText) {
    return _encrypter.encrypt(plainText, iv: _iv).base64;
  }

  static String decryptText(String encryptedText) {
    return _encrypter.decrypt64(encryptedText, iv: _iv);
  }
}
