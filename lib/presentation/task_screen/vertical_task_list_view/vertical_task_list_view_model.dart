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

abstract class VerticalTaskListAction {
  String get message;
}

class UpdateTaskAction implements VerticalTaskListAction {
  @override
  String get message => 'Tarefa atualizada com sucesso';
}

class RemoveTaskAction implements VerticalTaskListAction {
  @override
  String get message => 'Tarefa removida com sucesso';
}

class FailAction implements VerticalTaskListAction {
  FailAction({
    @required this.action,
  }) : assert(action != null);

  final VerticalTaskListAction action;

  @override
  String get message => action is UpdateTaskAction
      ? 'Falha ao atualizar tarefa'
      : 'Falha ao remover tarefa';
}
