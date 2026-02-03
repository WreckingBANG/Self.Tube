import 'package:Self.Tube/common/ui/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/features/tasks/data/api/task_api.dart';
import 'package:Self.Tube/features/tasks/ui/dialogs/add_video_dialog.dart';
import 'package:Self.Tube/features/tasks/ui/sections/queue_section.dart';
import 'package:Self.Tube/features/tasks/ui/sections/task_section.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class ActionsScreen extends StatelessWidget {
  const ActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) => AddVideoDialog()
          );
        },
        child: Icon(Icons.add),
      ),
      body: RefreshContainer(
        child: Column(
          children: [
            TaskSection(),
            Row(
              children: [
              Expanded(child: 
                ElevatedButton(
                  onPressed: () {
                    TaskApi().rescanSubscriptions();
                  },
                  child: Text("Rescan Subs"),
                ),
              ),
              Expanded(child: 
                ElevatedButton(
                  onPressed: () {
                    TaskApi().startDownloads();
                  },
                  child: Text("Start Downloads"),
                )
              )
              ]
            ),
            QueueSection(hideChannel: false, query: "")
          ],
        )
      )
    );
  }
}
