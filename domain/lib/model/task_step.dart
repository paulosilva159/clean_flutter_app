import 'package:domain/common/task_status.dart';
import 'package:meta/meta.dart';

class TaskStep {
  TaskStep({
    @required this.id,
    @required this.title,
    @required this.creationTime,
    this.status = TaskStatus.undone,
  })  : assert(id != null),
        assert(title != null),
        assert(creationTime != null);

  final String id;
  final String title;
  final TaskStatus status;
  final DateTime creationTime;
}
