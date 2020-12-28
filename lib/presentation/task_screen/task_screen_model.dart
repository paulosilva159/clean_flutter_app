import 'package:meta/meta.dart';

abstract class TaskScreenState {}

class Waiting implements TaskScreenState {}

class Done implements TaskScreenState {
  Done({
    @required this.listSize,
  }) : assert(listSize != null);

  final int listSize;
}

enum TaskScreenActionType {
  addTask,
}

abstract class TaskScreenAction {
  TaskScreenAction({
    @required this.type,
  }) : assert(type != null);

  final TaskScreenActionType type;
}

class ShowFailTaskAction extends TaskScreenAction {
  ShowFailTaskAction({@required TaskScreenActionType type})
      : assert(type != null),
        super(type: type);
}

class ShowSuccessTaskAction extends TaskScreenAction {
  ShowSuccessTaskAction({@required TaskScreenActionType type})
      : assert(type != null),
        super(type: type);
}
