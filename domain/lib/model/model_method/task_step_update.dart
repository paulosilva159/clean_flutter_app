import 'package:domain/common/task_status.dart';
import 'package:domain/model/task_step.dart';

extension UpdateParameter on TaskStep {
  TaskStep update({
    String newTitle,
    TaskStatus newStatus,
  }) =>
      TaskStep(
        id: id,
        creationTime: creationTime,
        title: newTitle ?? title,
        status: newStatus ?? status,
      );
}
