import 'package:domain/model/task.dart';
import 'package:meta/meta.dart';

class ReorderableTaskIds {
  ReorderableTaskIds({
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

enum VerticalTaskListActionType {
  reorderTask,
  updateTask,
  removeTask,
}

abstract class VerticalTaskListAction {
  VerticalTaskListAction({
    @required this.type,
  }) : assert(type != null);

  final VerticalTaskListActionType type;
}

class ShowFailTaskAction extends VerticalTaskListAction {
  ShowFailTaskAction({@required VerticalTaskListActionType type})
      : assert(type != null),
        super(type: type);
}

class ShowSuccessTaskAction extends VerticalTaskListAction {
  ShowSuccessTaskAction({@required VerticalTaskListActionType type})
      : assert(type != null),
        super(type: type);
}
