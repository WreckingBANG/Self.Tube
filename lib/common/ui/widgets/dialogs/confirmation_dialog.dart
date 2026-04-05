import 'package:flutter/material.dart';

Future<void> ConfirmationDialog({
  required BuildContext context,
  required VoidCallback onSure,
  List<Widget>? children,
  String? delText,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Are you sure?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (delText != null)
              Text("*Placeholder *Are you sure you want to delete $delText"),
            if(children != null)
              ...children
          ],
        ),
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

