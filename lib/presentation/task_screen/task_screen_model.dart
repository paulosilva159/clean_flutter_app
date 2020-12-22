abstract class TaskScreenState {}

class WaitingData implements TaskScreenState {}

class DataLoaded implements TaskScreenState {}

abstract class TaskScreenAction {
  String get message;
}

class AddTaskAction implements TaskScreenAction {
  @override
  String get message => 'Tarefa adicionada com sucesso';
}

class FailAction implements TaskScreenAction {
  @override
  String get message => 'Falha ao adicionar tarefa';
}
