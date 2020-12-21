import 'package:meta/meta.dart';

import 'package:domain/model/task.dart';

abstract class VerticalTaskListViewState {}

class Loading implements VerticalTaskListViewState {}

class Error implements VerticalTaskListViewState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}

abstract class Success implements VerticalTaskListViewState {
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

abstract class VerticalTaskListAction {}

class UpdateTaskAction implements VerticalTaskListAction {}

class RemoveTaskAction implements VerticalTaskListAction {}
