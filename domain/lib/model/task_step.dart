import 'package:domain/model/task_status.dart';
import 'package:meta/meta.dart';

class TaskStep {
  TaskStep({
    @required this.id,
    @required this.title,
    @required this.status,
  })  : assert(id != null),
        assert(title != null),
        assert(status != null);

  final int id;
  final String title;
  final TaskStatus status;
}
