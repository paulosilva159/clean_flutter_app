import 'package:meta/meta.dart';

import 'package:domain/model/task.dart';

abstract class TaskListViewState {}

class Loading implements TaskListViewState {}

class Error implements TaskListViewState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}

abstract class Success implements TaskListViewState {
  Success({@required this.tasks}) : assert(tasks != null);

  final List<Task> tasks;
}

class Empty extends Success {
  Empty() : super(tasks: const <Task>[]);
}

class Listing extends Success {
  Listing({@required List<Task> tasks})
      : assert(tasks != null),
        super(tasks: tasks);
}

abstract class TaskScreenAction {}

class UpdateTaskAction implements TaskScreenAction {}

class RemoveTaskAction implements TaskScreenAction {}
