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

  int get listSize => tasks.length;
}

class Empty extends Success {
  Empty() : super(tasks: const <Task>[]);
}

class Listing extends Success {
  Listing({@required List<Task> tasks})
      : assert(tasks != null),
        super(tasks: tasks);
}

abstract class VerticalTaskListAction {
  VerticalTaskListAction({@required this.message}) : assert(message != null);

  final String message;
}

class UpdateTaskAction extends VerticalTaskListAction {
  UpdateTaskAction({
    @required String message,
  })  : assert(message != null),
        super(message: message);
}

class RemoveTaskAction extends VerticalTaskListAction {
  RemoveTaskAction({
    @required String message,
  })  : assert(message != null),
        super(message: message);
}

class FailAction extends VerticalTaskListAction {
  FailAction({
    @required String message,
  })  : assert(message != null),
        super(message: message);
}
