import 'package:domain/common/task_status.dart';
import 'package:meta/meta.dart';

class TaskStep {
  TaskStep({
    @required this.id,
    @required this.title,
    @required this.status,
    @required this.creationTime,
  })  : assert(id != null),
        assert(title != null),
        assert(status != null),
        assert(creationTime != null);

  final int id;
  final String title;
  final TaskStatus status;
  final DateTime creationTime;
}
