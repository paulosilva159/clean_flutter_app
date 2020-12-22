import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'package:domain/model/task.dart';

import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/task_action_form_dialog.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    @required this.onRemoveTask,
    @required this.onUpdateTask,
    @required this.tasks,
  })  : assert(tasks != null),
        assert(onUpdateTask != null),
        assert(onRemoveTask != null);

  final void Function(Task) onRemoveTask;
  final void Function(Task) onUpdateTask;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) => Material(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => _TaskListItem(
            onRemoveTask: onRemoveTask,
            onUpdateTask: onUpdateTask,
            task: tasks[index],
          ),
          itemCount: tasks.length,
        ),
      );
}

class _TaskListItem extends StatelessWidget {
  const _TaskListItem({
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
                    showUpsertTaskFormDialog(
                      context,
                      formDialogTitle: S.of(context).updateTaskDialogTitle,
                      onUpsertTask: onUpdateTask,
                      upsertingTask: task,
                    );
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
