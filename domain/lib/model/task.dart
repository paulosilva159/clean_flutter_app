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
    this.days,
    this.steps,
    this.periodicity,
    this.progress,
  })  : assert(id != null),
        assert(title != null),
        assert(status != null),
        assert(orientation != null);

  final int id;
  final int days;
  final List<TaskStep> steps;
  final int periodicity;
  final int progress;
  final String title;
  final TaskStatus status;
  final TaskListOrientation orientation;
}
