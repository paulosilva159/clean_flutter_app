import 'package:domain/model/task.dart';
import 'package:flutter/material.dart';

class DeleteTaskButton extends StatelessWidget {
  const DeleteTaskButton({
    @required this.task,
    @required this.onRemoveTask,
    this.iconSize = 24.0,
  })  : assert(task != null),
        assert(onRemoveTask != null);

  final Task task;
  final double iconSize;
  final void Function(Task) onRemoveTask;

  @override
  Widget build(BuildContext context) => Expanded(
        child: IconButton(
          iconSize: iconSize,
          icon: const Icon(Icons.delete),
          onPressed: () {
            // TODO(paulosilva159): aplicar action que chama showform no actionlistener

            // AdaptiveAlertDialog(
            //   title: S.of(context).deleteTaskDialogTitle,
            //   message: S.of(context).deleteTaskDialogMessage,
            //   actions: [
            //     AdaptiveAlertDialogAction(
            //       title: S.of(context).confirmDialogActionTitle,
            //       isDefaultAction: true,
            //       onPressed: () {
            //         onRemoveTask(task);
            //
            //         Navigator.of(context).pop();
            //       },
            //     ),
            //     AdaptiveAlertDialogAction(
            //       title: S.of(context).cancelDialogActionTitle,
            //       isDefaultAction: false,
            //     ),
            //   ],
            // ).show(context);
          },
        ),
      );
}
