import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/tasks/domain/task_provider.dart';
import 'package:Self.Tube/features/tasks/ui/tiles/task_list_tile.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskSection extends ConsumerWidget {
  final String title;
  final bool hideIfEmpty;

  TaskSection({
    super.key,
    this.title = "",
    this.hideIfEmpty = false,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final tasks = ref.watch(taskProvider);
    
    return tasks.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
      data: (tasks) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tasks == null || tasks.isEmpty)
              SizedBox() 
            else
              ListSectionContainer(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskListTile(
                    task: task
                  );
                },
              )
          ],
        );
      }
    );
  }
}
