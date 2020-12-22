import 'package:meta/meta.dart';

import 'package:domain/data_repository/task_repository.dart';

class Task {
  const Task(
      {@required this.id, @required this.title, @required this.orientation})
      : assert(id != null),
        assert(title != null),
        assert(orientation != null);

  final int id;
  final String title;
  final TaskListOrientation orientation;
}
