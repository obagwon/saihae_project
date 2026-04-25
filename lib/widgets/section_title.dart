import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? description;
  final EdgeInsetsGeometry margin;

  const SectionTitle({
    super.key,
    required this.title,
    this.description,
    this.margin = const EdgeInsets.only(bottom: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (description != null) ...[
            const SizedBox(height: 6),
            Text(
              description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}