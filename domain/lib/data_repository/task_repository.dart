import 'dart:async';

import 'package:domain/model/task.dart';
import 'package:meta/meta.dart';

abstract class TaskDataRepository {
  const TaskDataRepository();

  Future<List<Task>> getTaskList(TaskListOrientation orientation);

  Future<void> upsertTask(Task task);

  Future<void> removeTask(Task task);

  Future<void> reorderTask(
    TaskListOrientation orientation, {
    @required int oldId,
    @required int newId,
  });
}

enum TaskListOrientation {
  vertical,
  horizontal,
}
