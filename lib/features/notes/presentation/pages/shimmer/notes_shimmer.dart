import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotesShimmer extends StatelessWidget {
  const NotesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: const Card(
            child: ListTile(
              title: SizedBox(height: 16, width: double.infinity),
              subtitle: SizedBox(height: 12, width: double.infinity),
            ),
          ),
        ),
      ),
    );
  }
}