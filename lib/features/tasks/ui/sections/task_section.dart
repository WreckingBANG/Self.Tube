import 'dart:async';
import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/tasks/data/models/task_model.dart';
import 'package:Self.Tube/features/tasks/ui/tiles/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/features/tasks/data/api/task_api.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class TaskSection extends StatefulWidget {
  final String title;
  final bool hideIfEmpty;

  const TaskSection({
    super.key,
    this.title = "",
    this.hideIfEmpty = false,
  });

  @override
  State<TaskSection> createState() => _TaskSectionState();
}

class _TaskSectionState extends State<TaskSection> {
  List<TaskModel>? tasks = [];
  int currentPage = 1;
  bool isLoading = false;


  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    fetchTasks();
  
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      fetchTasks();
    });
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchTasks() async {

    try {
      final result = await TaskApi().fetchTasks();
      setState(() {
        tasks = result;
      });
    } catch (e) {
      print("Error fetching playlists: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tasks!.isEmpty && !widget.hideIfEmpty && !isLoading)
          SizedBox() 
        else
          ListSectionContainer(
            title: widget.title,
            children: [
              ...List.generate(tasks!.length, (index) {
                final task = tasks![index];
                return TaskListTile(task: task);
              })
            ]
          ),
      ],
    );
  }
}
