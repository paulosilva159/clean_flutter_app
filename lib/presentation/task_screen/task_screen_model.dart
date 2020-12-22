import 'package:meta/meta.dart';

abstract class TaskScreenState {}

class WaitingData implements TaskScreenState {}

class DataLoaded implements TaskScreenState {}

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
