import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;

  const CustomAppBar({super.key, 
    required this.child,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor, // Background color
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor, // Border color
          width: 2.0, // Border width
        ),
        borderRadius: BorderRadius.circular(0.0), // Border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: preferredSize.height,
      alignment: Alignment.center,
      child: child,
    );
  }
}
