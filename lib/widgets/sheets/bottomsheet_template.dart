import 'package:flutter/material.dart';

Future<void> showBottomSheetTemplate({
  required BuildContext context,
  required final List<Widget> children,
  String? title,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
            ...children
          ],
        ),
      );
    },
  );
}
