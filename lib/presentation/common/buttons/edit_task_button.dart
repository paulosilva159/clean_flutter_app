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
            // TODO(paulosilva159): aplicar showForm
          },
        ),
      );
}
