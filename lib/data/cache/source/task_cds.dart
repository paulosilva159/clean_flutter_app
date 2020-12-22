import 'dart:async';

import 'package:hive/hive.dart';

import 'package:clean_flutter_app/data/cache/model/task_cm.dart';

class TaskCDS {
  static const String _taskListBoxName = '_taskListBoxName';

  Future<List<TaskCM>> getTaskList() =>
      Hive.openBox<TaskCM>(_taskListBoxName).then<List<TaskCM>>(
        (box) => box.values.toList(),
      );

  Future<void> upsertTask(TaskCM task) =>
      Hive.openBox<TaskCM>(_taskListBoxName).then<void>(
        (box) {
          box.values.contains(task)
              ? box.putAt(task.id, task)
              : box.put(task.id, task);
        },
      );

  Future<void> removeTask(TaskCM task) =>
      Hive.openBox<TaskCM>(_taskListBoxName).then<void>((box) {
        final _laterIndexItems =
            box.values.where((boxTask) => boxTask.id > task.id);
        final _isLastIndex = _laterIndexItems?.isEmpty == true;

        if (_isLastIndex) {
          box.delete(task.id);
        } else {
          _laterIndexItems.forEach(
            (boxTask) {
              final _newIndex = boxTask.id - 1;

              box.put(
                _newIndex,
                TaskCM(
                  id: _newIndex,
                  title: boxTask.title,
                  orientation: boxTask.orientation,
                ),
              );
            },
          );

          box.delete(_laterIndexItems.last.id);
        }
      });
}
