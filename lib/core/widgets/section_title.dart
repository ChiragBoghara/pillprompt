import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(letterSpacing: 1.2),
    );
  }
}
