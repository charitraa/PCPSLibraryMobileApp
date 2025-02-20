import 'package:flutter/material.dart';

class NotificationHeader extends StatelessWidget {
  final String title;

  const NotificationHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}