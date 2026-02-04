import 'package:Self.Tube/features/tasks/data/api/task_api.dart';
import 'package:flutter/material.dart';

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
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
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
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    TaskApi().stopTask(task.taskId);
                  },
                  icon: const Icon(Icons.pause),
                ),
              ],
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
