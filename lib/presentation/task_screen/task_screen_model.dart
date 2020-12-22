import 'package:meta/meta.dart';

abstract class TaskScreenState {}

class Waiting implements TaskScreenState {}

class Done implements TaskScreenState {
  Done({
    @required this.listSize,
  }) : assert(listSize != null);

  final int listSize;
}

abstract class TaskScreenAction {
  TaskScreenAction({@required this.message}) : assert(message != null);

  final String message;
}

class AddTaskAction extends TaskScreenAction {
  AddTaskAction({
    @required String message,
  })  : assert(message != null),
        super(message: message);
}

class FailAction extends TaskScreenAction {
  FailAction({
    @required String message,
  })  : assert(message != null),
        super(message: message);
}
