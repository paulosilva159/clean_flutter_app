import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/task_action_form_dialog.dart';
import 'package:domain/model/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// TODO(paulosilva159): Refazer ReorderableListView

class TaskList extends StatelessWidget {
  const TaskList({
    @required this.onRemoveTask,
    @required this.onUpdateTask,
    @required this.onReorderTasks,
    @required this.tasks,
  })  : assert(tasks != null),
        assert(onUpdateTask != null),
        assert(onRemoveTask != null),
        assert(onReorderTasks != null);

  final void Function(Task) onRemoveTask;
  final void Function(Task) onUpdateTask;
  final void Function(int, int) onReorderTasks;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) => Material(
        child: ReorderableListView(
          onReorder: (oldId, newId) {
            onReorderTasks(
              oldId + 1,
              newId > oldId ? newId : newId + 1,
            );
          },
          children: tasks
              .map((task) => _TaskListItem(
                    key: ValueKey<int>(task.id),
                    onRemoveTask: onRemoveTask,
                    onUpdateTask: onUpdateTask,
                    task: task,
                  ))
              .toList(),
        ),
      );
}

class _TaskListItem extends StatelessWidget {
  const _TaskListItem({
    @required this.task,
    @required this.onRemoveTask,
    @required this.onUpdateTask,
    Key key,
  })  : assert(task != null),
        assert(onRemoveTask != null),
        assert(onUpdateTask != null),
        super(key: key);

  final Task task;
  final void Function(Task) onRemoveTask;
  final void Function(Task) onUpdateTask;

  RoundedRectangleBorder _listTileCardShape() => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      );

  @override
  Widget build(BuildContext context) => Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        shape: _listTileCardShape(),
        color: Colors.amber,
        child: ListTile(
          onTap: () {
            print('t');
          },
          shape: _listTileCardShape(),
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
        ),
      );
}
