import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/adaptive_form_dialog.dart';
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
  final void Function(Task) onRemoveTask;
  final void Function(Task) onUpdateTask;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Text('#${task.id}'),
        title: Text(task.title),
        trailing: Container(
          width: 75,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    AdaptiveFormDialog(
                      formDialogTitle: 'update',
                      onUpsertTask: onUpdateTask,
                      updatingTask: task,
                      child: Container(),
                    ).show(context);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.remove_circle_rounded),
                  onPressed: () => onRemoveTask(task),
                ),
              ),
            ],
          ),
        ),
      );
}
