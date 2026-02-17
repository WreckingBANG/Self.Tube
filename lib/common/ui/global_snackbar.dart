
import 'package:flutter/material.dart';

class GlobalSnackbar {
  static final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void show(
    String message, {
    String? actionLabel,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    bool autoDismiss = true,
  }) {
    final messenger = key.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();

    final snackBar = SnackBar(
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(message),
          )
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
    
    if (autoDismiss) {
      Future.delayed(duration, () {
        final current = key.currentState;
        if (current != null) {
          current.hideCurrentSnackBar();
        }
      });
    }
  }
}

