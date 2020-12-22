import 'package:meta/meta.dart';

abstract class TaskScreenState {}

class Waiting implements TaskScreenState {}

class Done implements TaskScreenState {
  Done({
    @required this.listSize,
  }) : assert(listSize != null);

  final int listSize;
}

abstract class TaskScreenAction {}

class ShowAddTaskAction implements TaskScreenAction {}

class ShowFailTaskAction implements TaskScreenAction {}
