import 'package:Self.Tube/features/videos/domain/selection_provider.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> ProgressDialog({
  required BuildContext context,
  required String query,
  required Function action,
  required WidgetRef ref,
  List<Widget>? children,
  String? delText,
}) async {
  
  final totalItems = ref.read(selectionProvider(query)).length;
  
  action();

  showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, dialogRef, child) {
          final localizations = AppLocalizations.of(context)!;

          final currentItems = dialogRef.watch(selectionProvider(query)).length;
          final progress = totalItems == 0 ? 0.0 : (totalItems - currentItems) / totalItems;

          if(dialogRef.watch(selectionProvider(query)).isEmpty) {
            Navigator.of(context).pop();
          }

          return AlertDialog(
            title: Text(localizations.sheetActionExec),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0)
                ),
                SizedBox(width: 10),
                Text("${totalItems - currentItems} / $totalItems"),
                SizedBox(width: 15),
                Row(
                  children: [
                    Icon(Icons.info_rounded),
                    SizedBox(width: 10),
                    Text(localizations.sheetActionInfo)
                  ],
                )
              ],
            ),
          );
        },
      );
    },
  );
}

