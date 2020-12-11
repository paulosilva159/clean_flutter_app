import 'package:meta/meta.dart';

import 'package:domain/model/task.dart';

abstract class TaskScreenState {}

class Loading implements TaskScreenState {}

class Error implements TaskScreenState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}

abstract class Success implements TaskScreenState {
  Success({@required this.tasks}) : assert(tasks != null);

  final List<Task> tasks;
}

class Empty extends Success {
  Empty() : super(tasks: <Task>[]);
}

class Listing extends Success {
  Listing({@required List<Task> tasks})
      : assert(tasks != null),
        super(tasks: tasks);
}
