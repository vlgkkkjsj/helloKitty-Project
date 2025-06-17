import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String emoji;

  const TaskTile({
    super.key,
    required this.icon,
    required this.title,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(icon, color: Colors.pink),
      ),
    );
  }
}
