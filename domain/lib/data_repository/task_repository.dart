import 'dart:async';

import 'package:domain/model/task.dart';

abstract class TaskDataRepository {
  const TaskDataRepository();

  Future<List<Task>> getTaskList();

  Future<void> addTask(Task task);

  Future<void> removeTask(Task task);
}
