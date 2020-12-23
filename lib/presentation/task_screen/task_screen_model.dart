import 'package:meta/meta.dart';

abstract class TaskScreenState {}

class Waiting implements TaskScreenState {}

class Done implements TaskScreenState {
  Done({
    @required this.listSize,
  }) : assert(listSize != null);

  final int listSize;
}

abstract class TaskScreenActionType {}

class AddTaskAction implements TaskScreenActionType {}

abstract class TaskScreenAction {
  TaskScreenAction({
    @required this.actionType,
  }) : assert(actionType != null);

  final TaskScreenActionType actionType;
}

class ShowFailTaskAction extends TaskScreenAction {
  ShowFailTaskAction({@required TaskScreenActionType actionType})
      : assert(actionType != null),
        super(actionType: actionType);
}

class ShowSuccessTaskAction extends TaskScreenAction {
  ShowSuccessTaskAction({@required TaskScreenActionType actionType})
      : assert(actionType != null),
        super(actionType: actionType);
}
