import 'package:flutter/material.dart';

Future<void> ConfirmationDialog({
  required BuildContext context,
  required VoidCallback onSure,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Yes"),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    onSure();
  }
}

