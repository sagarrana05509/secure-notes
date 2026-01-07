import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_notes/features/notes/presentation/bloc/events/notes_events.dart';
import 'package:secure_notes/features/notes/presentation/bloc/notes_bloc.dart';

class SearchAndSortBar extends StatelessWidget {
  const SearchAndSortBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NotesBloc>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search notes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                bloc.add(SearchNote(value));
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              bloc.ascending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            onPressed: () {
              bloc.add(SortNotes(!bloc.ascending));
            },
          ),
        ],
      ),
    );
  }
}