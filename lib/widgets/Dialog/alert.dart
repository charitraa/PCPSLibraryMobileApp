import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;
  final List<Widget> actions;

  const Alert({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actions: actions,
    );
  }
}
