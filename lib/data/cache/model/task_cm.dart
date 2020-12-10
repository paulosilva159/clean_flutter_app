import 'package:meta/meta.dart';

class TaskCM {
  const TaskCM({
    @required this.title,
    @required this.id,
  })  : assert(title != null),
        assert(id != null);

  final String title;
  final int id;
}
