import 'package:domain/model/task.dart';
import 'package:meta/meta.dart';

class ReorderingTaskIds {
  ReorderingTaskIds({
    @required this.oldId,
    @required this.newId,
  })  : assert(oldId != null),
        assert(newId != null);

  final int oldId;
  final int newId;
}

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

abstract class VerticalTaskListAction {}

class ShowReorderTaskAction extends VerticalTaskListAction {}

class ShowUpdateTaskAction extends VerticalTaskListAction {}

class ShowRemoveTaskAction extends VerticalTaskListAction {}

class ShowFailTaskAction extends VerticalTaskListAction {}
