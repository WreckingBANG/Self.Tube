import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/common/utils/timeago_formatter.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class TaskListTile extends StatelessWidget {
  final dynamic task;

  const TaskListTile({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    task.messages.toString(),
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: task.progress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
