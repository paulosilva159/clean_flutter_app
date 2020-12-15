import 'package:flutter/material.dart';

import 'package:domain/model/task.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    @required this.task,
    @required this.onRemoveTask,
    @required this.onUpdateTask,
  })  : assert(task != null),
        assert(onRemoveTask != null),
        assert(onUpdateTask != null);

  final Task task;
  final Function(Task) onRemoveTask;
  final Function(Task) onUpdateTask;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Text(
          '#${task.id}',
        ),
        title: Text(task.title),
        trailing: IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => onRemoveTask(task),
        ),
      );
}
