import 'package:domain/common/task_list_orientation.dart';
import 'package:domain/common/task_priority.dart';
import 'package:domain/common/task_status.dart';
import 'package:domain/model/task_step.dart';
import 'package:meta/meta.dart';

class Task {
  Task({
    @required this.id,
    @required this.title,
    @required this.orientation,
    @required this.creationTime,
    this.status = TaskStatus.undone,
    this.priority = TaskPriority.normal,
    this.deadline,
    this.steps,
    this.periodicity,
  })  : assert(id != null),
        assert(title != null),
        assert(creationTime != null),
        assert(orientation != null),
        assert(
          (orientation == TaskListOrientation.horizontal && steps != null) ||
              (orientation == TaskListOrientation.vertical && deadline != null),
        );

  final String id;
  final int periodicity;
  final String title;
  final DateTime deadline;
  final DateTime creationTime;
  final TaskStatus status;
  final TaskPriority priority;
  final List<TaskStep> steps;
  final TaskListOrientation orientation;
}
