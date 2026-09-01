import 'package:flutter/material.dart';

class FastforwardOverlay extends StatelessWidget {
  const FastforwardOverlay({super.key, required this.playbackSpeedText});

  final String playbackSpeedText;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, -0.95),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                playbackSpeedText,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.fast_forward,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
