import 'package:domain/common/task_list_orientation.dart';
import 'package:domain/common/task_priority.dart';
import 'package:domain/common/task_status.dart';
import 'package:domain/model/task.dart';
import 'package:domain/model/task_step.dart';

extension UpdateParameter on Task {
  Task update({
    List<TaskStep> newSteps,
    TaskListOrientation newOrientation,
    TaskPriority newPriority,
    TaskStatus newStatus,
    int newPeriodicity,
    DateTime newDeadline,
    String newTitle,
  }) =>
      Task(
        id: id,
        creationTime: creationTime,
        title: newTitle ?? title,
        deadline: newDeadline ?? deadline,
        periodicity: newPeriodicity ?? periodicity,
        status: newStatus ?? status,
        priority: newPriority ?? priority,
        orientation: newOrientation ?? orientation,
        steps: newSteps ?? steps,
      );
}
