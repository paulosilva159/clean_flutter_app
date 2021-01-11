import 'package:domain/model/task.dart';
import 'package:meta/meta.dart';

abstract class HorizontalTaskListViewState {}

class Loading implements HorizontalTaskListViewState {}

class Error implements HorizontalTaskListViewState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}

abstract class Success implements HorizontalTaskListViewState {
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

enum HorizontalTaskListActionType {
  reorderTask,
  updateTask,
  removeTask,
}

abstract class HorizontalTaskListAction {
  HorizontalTaskListAction({
    @required this.type,
  }) : assert(type != null);

  final HorizontalTaskListActionType type;
}

class ShowFailTaskAction extends HorizontalTaskListAction {
  ShowFailTaskAction({@required HorizontalTaskListActionType type})
      : assert(type != null),
        super(type: type);
}

class ShowSuccessTaskAction extends HorizontalTaskListAction {
  ShowSuccessTaskAction({@required HorizontalTaskListActionType type})
      : assert(type != null),
        super(type: type);
}
