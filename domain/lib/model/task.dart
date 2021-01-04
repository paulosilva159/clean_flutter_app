import 'package:domain/model/task_list_orientation.dart';
import 'package:domain/model/task_status.dart';
import 'package:domain/model/task_step.dart';
import 'package:meta/meta.dart';

class Task {
  Task({
    @required this.id,
    @required this.title,
    @required this.status,
    @required this.orientation,
    this.deadline,
    this.steps,
    this.periodicity,
  })  : assert(id != null),
        assert(title != null),
        assert(status != null),
        assert(orientation != null);

  final int id;
  final DateTime deadline;
  final List<TaskStep> steps;
  final int periodicity;
  final String title;
  final TaskStatus status;
  final TaskListOrientation orientation;
}
