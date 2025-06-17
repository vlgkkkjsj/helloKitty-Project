import 'package:flutter/material.dart';

class SectionIcon extends StatelessWidget {
  final IconData icon;

  const SectionIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.pink[100],
      radius: 30,
      child: Icon(
        icon,
        color: Colors.brown,
      ),
    );
  }
}
