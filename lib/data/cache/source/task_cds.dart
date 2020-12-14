import 'dart:async';

import 'package:clean_flutter_app/data/cache/model/task_cm.dart';
import 'package:hive/hive.dart';

class TaskCDS {
  static const String _taskListBoxName = '_taskListBoxName';

  Future<List<TaskCM>> getTaskList() =>
      Hive.openBox<TaskCM>(_taskListBoxName).then<List<TaskCM>>(
        (box) => box.values.toList(),
      );

  Future<void> upsertTask(TaskCM task) =>
      Hive.openBox<TaskCM>(_taskListBoxName).then<void>(
        (box) => box.values.contains(task)
            ? box.putAt(task.id, task)
            : box.put(task.id, task),
      );

  Future<void> removeTask(TaskCM task) =>
      Hive.openBox(_taskListBoxName).then<void>(
        (box) => box.deleteAt(task.id),
      );
}
