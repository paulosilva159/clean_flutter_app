import 'package:meta/meta.dart';

class Task {
  const Task({
    @required this.id,
    @required this.title,
  })  : assert(id != null),
        assert(title != null);

  final int id;
  final String title;
}
