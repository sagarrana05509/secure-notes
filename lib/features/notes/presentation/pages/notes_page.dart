import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_notes/features/auth/presentation/bloc/event/auth_events.dart';
import 'package:secure_notes/features/auth/presentation/bloc/state/auth_state.dart';
import 'package:secure_notes/features/notes/presentation/bloc/events/notes_events.dart';
import 'package:secure_notes/features/notes/presentation/bloc/state/notes_states.dart';
import 'package:secure_notes/features/notes/presentation/pages/search_view.dart';
import 'package:secure_notes/features/notes/presentation/pages/shimmer/notes_shimmer.dart';
import 'package:secure_notes/features/notes/presentation/pages/widgets/common_notes_view.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/note.dart';
import '../bloc/notes_bloc.dart';
import 'empty_notes_view.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(LoadNotes());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogout) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Secure Notes'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _showLogoutDialog,
            ),
          ],
        ),
        body: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const NotesShimmer();
            }

            if (state is NotesLoaded) {
              return Column(
                children: [
                  SearchAndSortBar(),
                  Expanded(
                    child: state.notes.isEmpty
                        ? const EmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.all(12),
                            itemCount: state.notes.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (_, index) {
                              final note = state.notes[index];
                              return CommonNoteCard(
                                title: note.title,
                                subtitle: note.content,
                                onTap: () {
                                  _showEditNoteDialog(note);
                                },
                                onDelete: (){
                                  context.read<NotesBloc>().add(DeleteNote(note.id));
                                },

                              );
                            },
                          ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddNoteDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog() {
    final bloc = context.read<NotesBloc>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bloc.titleCtrl,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bloc.contentCtrl,
              decoration: const InputDecoration(hintText: 'Content'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              bloc.add(
                AddNote(
                  bloc.titleCtrl.text.trim(),
                  bloc.contentCtrl.text.trim(),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(Note note) {
    final bloc = context.read<NotesBloc>();

    bloc.titleCtrl.text = note.title;
    bloc.contentCtrl.text = note.content;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bloc.titleCtrl,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bloc.contentCtrl,
              decoration: const InputDecoration(hintText: 'Content'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              bloc.add(
                UpdateNote(
                  id: note.id,
                  title: bloc.titleCtrl.text.trim(),
                  content: bloc.contentCtrl.text.trim(),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
