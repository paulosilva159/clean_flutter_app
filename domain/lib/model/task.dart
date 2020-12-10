import 'package:meta/meta.dart';

class Task {
  Task({@required this.title}) : assert(title != null);

  final String title;
}
