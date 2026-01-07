import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/encryption/encryption_helper.dart';
import '../domain/note.dart';

class NotesLocalDataSource {
  final storage = const FlutterSecureStorage();

  Future<List<Note>> getNotes() async {
    final data = await storage.read(key: 'notes');
    if (data == null) return [];

    final decrypted = EncryptionHelper.decryptText(data);
    final list = jsonDecode(decrypted) as List;

    return list.map((e) => Note(
      id: e['id'],
      title: e['title'],
      content: e['content'],
      createdAt: DateTime.parse(e['createdAt']),
    )).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final encoded = jsonEncode(notes.map((e) => {
      'id': e.id,
      'title': e.title,
      'content': e.content,
      'createdAt': e.createdAt.toIso8601String(),
    }).toList());

    final encrypted = EncryptionHelper.encryptText(encoded);
    await storage.write(key: 'notes', value: encrypted);
  }

}
