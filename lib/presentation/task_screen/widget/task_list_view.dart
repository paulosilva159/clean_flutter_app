import 'package:flutter/material.dart';

import 'package:domain/model/task.dart';

import 'package:clean_flutter_app/presentation/task_screen/widget/task_list_item.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({
    @required this.tasks,
    @required this.onRemoveTaskItem,
    @required this.onUpdateTaskItem,
  })  : assert(tasks != null),
        assert(onRemoveTaskItem != null);

  final List<Task> tasks;
  final Function(Task) onRemoveTaskItem;
  final Function(Task) onUpdateTaskItem;

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (context, index) => TaskListItem(
          onRemoveTask: onRemoveTaskItem,
          onUpdateTask: onUpdateTaskItem,
          task: tasks[index],
        ),
        itemCount: tasks.length,
      );
}
