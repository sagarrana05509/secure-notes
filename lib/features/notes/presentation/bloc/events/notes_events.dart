
sealed class NotesEvent {}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final String title, content;

  AddNote(this.title, this.content);
}

class SearchNote extends NotesEvent {
  final String query;

  SearchNote(this.query);
}

class SortNotes extends NotesEvent {
  final bool ascending;

  SortNotes(this.ascending);
}

class DeleteNote extends NotesEvent {
  final String id;

  DeleteNote(this.id);
}
class UpdateNote extends NotesEvent {
  final String id;
  final String title;
  final String content;
  UpdateNote({
    required this.id,
    required this.title,
    required this.content,
  });
}