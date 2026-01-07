import 'package:flutter/material.dart';

class CommonNoteCard extends StatelessWidget {
  const CommonNoteCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onDelete,
    this.elevation = 2,
    this.maxLines = 2,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final double elevation;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed:  onTap,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed:  onDelete,
              tooltip: 'Edit',
            ),
          ],
        ),
      ),
    );
  }
}
