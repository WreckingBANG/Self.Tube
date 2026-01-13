import 'package:flutter/material.dart';

class GestureMessage extends StatelessWidget {
  final String message;
  final IconData icon;

  const GestureMessage({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                message,
                style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        )
      ),
    );
  }
}
