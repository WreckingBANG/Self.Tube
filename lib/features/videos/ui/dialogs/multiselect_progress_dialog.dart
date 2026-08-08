import 'package:Self.Tube/features/videos/domain/selection_provider.dart';
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
  
  final select = ref.read(selectionProvider(query).notifier);

  final totalItems = ref.read(selectionProvider(query)).length;
  
  action();

  showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, dialogRef, child) {
          final currentItems = dialogRef.watch(selectionProvider(query)).length;
          final progress = totalItems == 0 ? 0.0 : (totalItems - currentItems) / totalItems;

          if(dialogRef.watch(selectionProvider(query)).isEmpty) {
            Navigator.of(context).pop();
          }

          return AlertDialog(
            title: Text("Executing Action"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${totalItems - currentItems} / $totalItems"),
                CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0)
                ),
                Row(
                  children: [
                    Icon(Icons.info_rounded),
                    Text("Please do not close this Dialog")
                  ],
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  select.clear();
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
            ],
          );
        },
      );
    },
  );
}

