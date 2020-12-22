import 'dart:async';

import 'package:meta/meta.dart';

import 'package:domain/model/task.dart';

abstract class TaskDataRepository {
  const TaskDataRepository();

  Future<List<Task>> getTaskList({@required TaskListOrientation orientation});

  Future<void> upsertTask(Task task);

  Future<void> removeTask(Task task);
}

enum TaskListOrientation {
  vertical,
  horizontal,
}
