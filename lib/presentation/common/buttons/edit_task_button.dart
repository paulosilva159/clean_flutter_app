import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/task_action_form_dialog.dart';
import 'package:domain/model/task.dart';
import 'package:flutter/material.dart';

class UpdateTaskButton extends StatelessWidget {
  const UpdateTaskButton({
    @required this.task,
    @required this.onUpdateTask,
    this.iconSize = 24.0,
  })  : assert(task != null),
        assert(onUpdateTask != null);

  final Task task;
  final double iconSize;
  final void Function(Task) onUpdateTask;

  @override
  Widget build(BuildContext context) => Expanded(
        child: IconButton(
          iconSize: iconSize,
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
      );
}
