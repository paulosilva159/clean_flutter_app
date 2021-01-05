import 'dart:async';

import 'package:domain/common/task_list_orientation.dart';
import 'package:domain/model/task.dart';

abstract class TaskDataRepository {
  const TaskDataRepository();

  Future<List<Task>> getTaskList(
    TaskListOrientation orientation,
  );

  Future<void> upsertTask(Task task);

  Future<void> removeTask(Task task);
}
