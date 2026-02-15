
import 'package:flutter/material.dart';

class GlobalSnackbar {
  static final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void show(
    String message, {
    String? actionLabel,
    IconData? icon,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = key.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();

    final snackBar = SnackBar(
      duration: duration,
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon),
            const SizedBox(width: 10),
          ],
          Text(message),
        ],
      ),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction,
            )
          : null,
    );

    messenger.showSnackBar(snackBar);

    Future.delayed(duration, () {
      final current = key.currentState;
      if (current != null) {
        current.hideCurrentSnackBar();
      }
    });
  }
}

