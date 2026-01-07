import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_notes/features/notes/presentation/bloc/state/notes_states.dart';
import '../../data/notes_local_ds.dart';
import '../../domain/note.dart';
import 'dart:math';
import 'events/notes_events.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final titleCtrl = TextEditingController();

  final contentCtrl = TextEditingController();
  final ds = NotesLocalDataSource();
  String _query = '';
  bool ascending = true;
  List<Note> allNotes = [];

  NotesBloc() : super(NotesLoading()) {
    on<LoadNotes>((_, emit) async {
      allNotes = await ds.getNotes();

      emit(NotesLoaded(allNotes));

    });

    on<AddNote>((e, emit) async {
      final notes = allNotes;
      notes.add(
        Note(
          id: Random().nextInt(99999).toString(),
          title: e.title,
          content: e.content,
          createdAt: DateTime.now(),
        ),
      );
      await ds.saveNotes(notes);
      titleCtrl.clear();
      contentCtrl.clear();
      emit(NotesLoaded(notes));
    });

    on<DeleteNote>((e, emit) async {
      final notes = allNotes;
      notes.removeWhere((n) => n.id == e.id);
      await ds.saveNotes(notes);
      emit(NotesLoaded(notes));
    });

    on<SearchNote>((e, emit) async {
      _query = e.query;
      final list = await ds.getNotes();
      if (_query.isEmpty) {

        emit(NotesLoaded(list));
        return;
      } else {
        final filtered = list.where((note) {
          final q = _query.toLowerCase();
          return note.title.toLowerCase().contains(q) ||
              note.content.toLowerCase().contains(q);
        }).toList();
        filtered.sort((a, b) => ascending
            ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
            : b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        allNotes = filtered;
        emit(NotesLoaded(filtered));
      }
    });

    on<SortNotes>((event, emit) async{
      ascending = event.ascending;
     await _emitFiltered(emit);
    });
    on<UpdateNote>((event, emit) async {
      final notes = await ds.getNotes();

      final updatedNotes = notes.map((n) {
        if (n.id == event.id) {
          return Note(
            id: n.id,
            title: event.title,
            content: event.content,
            createdAt: n.createdAt, // keep original date
          );
        }
        return n;
      }).toList();

      await ds.saveNotes(updatedNotes);
      emit(NotesLoaded(updatedNotes));
    });


  }

  _emitFiltered(Emitter<NotesState> emit) async {
    var list = allNotes;
    if (_query.isNotEmpty) {

     list = list.where((note) {
        final q = _query.toLowerCase();
        return note.title.toLowerCase().contains(q) ||
            note.content.toLowerCase().contains(q);
      }).toList();

    }

    list.sort(
          (a, b) => ascending
          ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
          : b.title.toLowerCase().compareTo(a.title.toLowerCase()),
    );

    await Future.delayed(const Duration(seconds: 0));

    if (emit.isDone) return;

    emit(NotesLoaded(list));
  }
}
