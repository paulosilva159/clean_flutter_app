import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:domain/model/task.dart';
import 'package:domain/use_case/add_task_uc.dart';

import 'package:clean_flutter_app/common/subscription_holder.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';
import 'package:clean_flutter_app/presentation/common/task_list_status.dart';

class TaskScreenBloc with SubscriptionHolder {
  TaskScreenBloc({
    @required this.useCases,
  }) : assert(useCases != null) {
    addTaskItemSubject(_onAddTaskItemSubject.stream);

    updateTaskListStatusSubject(_onNewTaskListStatusSubject.stream);
  }

  void addTaskItemSubject(Stream<Task> inputStream) => inputStream
      .flatMap<TaskScreenState>(
        (task) => _addData(task: task, actionSink: _onNewActionSubject.sink),
      )
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  void updateTaskListStatusSubject(Stream<TaskListStatus> inputStream) =>
      inputStream.listen((taskListStatus) {
        if (taskListStatus is TaskListLoaded) {
          _onNewStateSubject.add(
            Done(listSize: taskListStatus.listSize),
          );
        }
      }).addTo(subscriptions);

  final TaskScreenUseCases useCases;

  final _onNewActionSubject = PublishSubject<TaskScreenAction>();
  final _onAddTaskItemSubject = PublishSubject<Task>();
  final _onNewStateSubject = BehaviorSubject<TaskScreenState>.seeded(
    Waiting(),
  );
  final _onNewTaskListStatusSubject = BehaviorSubject<TaskListStatus>.seeded(
    TaskListLoading(),
  );

  Sink<Task> get onAddTaskItem => _onAddTaskItemSubject.sink;
  Sink<TaskListStatus> get onNewTaskListStatus =>
      _onNewTaskListStatusSubject.sink;

  Stream<TaskScreenState> get onNewState => _onNewStateSubject.stream;
  Stream<TaskScreenAction> get onNewAction => _onNewActionSubject.stream;

  Stream<TaskScreenState> _addData({
    @required Task task,
    @required Sink<TaskScreenAction> actionSink,
  }) async* {
    try {
      await useCases.addTask(
        AddTaskUCParams(task: task),
      );

      actionSink.add(
        ShowAddTaskAction(),
      );
    } catch (error) {
      actionSink.add(
        ShowFailTaskAction(),
      );
    }
  }

  void dispose() {
    _onNewStateSubject.close();
    _onNewActionSubject.close();
    _onAddTaskItemSubject.close();
    _onNewTaskListStatusSubject.close();
    disposeSubscriptions();
  }
}

class TaskScreenUseCases {
  TaskScreenUseCases({
    @required this.addTaskUC,
  }) : assert(addTaskUC != null);

  final AddTaskUC addTaskUC;

  Future<void> addTask(AddTaskUCParams params) =>
      addTaskUC.getFuture(params: params);
}
