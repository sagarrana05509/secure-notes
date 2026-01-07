import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No notes found',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}