import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;
  final String tag;

  const CustomActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.color,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: tag,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      shape: const CircleBorder(),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
