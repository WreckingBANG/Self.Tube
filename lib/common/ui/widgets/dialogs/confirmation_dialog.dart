import 'package:Self.Tube/l10n/generated/app_localizations.dart';
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
      final localizations = AppLocalizations.of(context)!;
      
      return AlertDialog(
        title: Text(localizations.dialogConfirmSure),
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
            child: Text(localizations.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(localizations.dialogConfirmYes),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    onSure();
  }
}

