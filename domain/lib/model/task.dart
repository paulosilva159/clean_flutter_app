import 'package:meta/meta.dart';

class Task {
  Task({
    @required this.id,
    @required this.title,
  })  : assert(id != null),
        assert(title != null);

  final int id;
  final String title;
}
