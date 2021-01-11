import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:meta/meta.dart';

class CombinedTaskListStatus {
  CombinedTaskListStatus({
    @required this.verticalListStatus,
    @required this.horizontalListStatus,
  })  : assert(verticalListStatus != null),
        assert(horizontalListStatus != null);

  final TaskListStatus verticalListStatus;
  final TaskListStatus horizontalListStatus;
}

abstract class TaskScreenState {}

class Loading implements TaskScreenState {}

class Idle implements TaskScreenState {}

enum TaskScreenActionType {
  addTask,
}

abstract class TaskScreenAction {
  TaskScreenAction({
    @required this.type,
  }) : assert(type != null);

  final TaskScreenActionType type;
}

class ShowAddTaskFormAction extends TaskScreenAction {
  ShowAddTaskFormAction() : super(type: TaskScreenActionType.addTask);
}

class ShowFailTaskAction extends TaskScreenAction {
  ShowFailTaskAction({
    @required TaskScreenActionType type,
  })  : assert(type != null),
        super(type: type);
}

class ShowSuccessTaskAction extends TaskScreenAction {
  ShowSuccessTaskAction({
    @required TaskScreenActionType type,
  })  : assert(type != null),
        super(type: type);
}
