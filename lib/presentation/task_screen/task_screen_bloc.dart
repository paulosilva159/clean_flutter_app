import 'package:clean_flutter_app/common/subscription_holder.dart';
import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';
import 'package:domain/model/task.dart';
import 'package:domain/use_case/add_task_uc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class TaskScreenBloc with SubscriptionHolder {
  TaskScreenBloc({
    @required this.useCases,
  }) : assert(useCases != null) {
    _onAddTaskItemSubject.stream
        .listen(
          (task) => _addData(
            task: task,
            actionSink: _onNewActionSubject.sink,
          ),
        )
        .addTo(subscriptions);

    Rx.combineLatest2<TaskListStatus, TaskListStatus, CombinedTaskListStatus>(
      _onNewVerticalTaskListStatusSubject.stream,
      _onNewHorizontalTaskListStatusSubject.stream,
      (verticalListStatus, horizontalListStatus) => CombinedTaskListStatus(
        verticalListStatus: verticalListStatus,
        horizontalListStatus: horizontalListStatus,
      ),
    ).distinct().listen(
      (combinedTaskListStatus) {
        final _lastListingState = _onNewStateSubject.value;

        if (_lastListingState is! Idle &&
            combinedTaskListStatus.horizontalListStatus is TaskListLoaded &&
            combinedTaskListStatus.verticalListStatus is TaskListLoaded) {
          _onNewStateSubject.add(
            Idle(),
          );
        }
      },
    ).addTo(subscriptions);
  }

  final TaskScreenUseCases useCases;

  final _onNewActionSubject = PublishSubject<TaskScreenAction>();
  final _onAddTaskItemSubject = PublishSubject<Task>();
  final _onNewStateSubject = BehaviorSubject<TaskScreenState>.seeded(
    Loading(),
  );
  final _onNewVerticalTaskListStatusSubject =
      BehaviorSubject<TaskListStatus>.seeded(
    TaskListLoading(),
  );
  final _onNewHorizontalTaskListStatusSubject =
      BehaviorSubject<TaskListStatus>.seeded(
    TaskListLoading(),
  );

  Sink<Task> get onAddTaskItem => _onAddTaskItemSubject.sink;
  Sink<TaskListStatus> get onNewVerticalTaskListStatus =>
      _onNewVerticalTaskListStatusSubject.sink;
  Sink<TaskListStatus> get onNewHorizontalTaskListStatus =>
      _onNewHorizontalTaskListStatusSubject.sink;
  Sink<TaskScreenAction> get onNewActionSink => _onNewActionSubject.sink;

  Stream<TaskScreenState> get onNewState => _onNewStateSubject.stream;
  Stream<TaskScreenAction> get onNewActionStream => _onNewActionSubject.stream;

  Future<void> _addData({
    @required Task task,
    @required Sink<TaskScreenAction> actionSink,
  }) async {
    const _actionType = TaskScreenActionType.addTask;

    await useCases
        .addTask(
          AddTaskUCParams(task: task),
        )
        .then(
          (_) => actionSink.add(
            ShowSuccessTaskAction(type: _actionType),
          ),
        )
        .catchError(
      (error) {
        actionSink.add(
          ShowFailTaskAction(type: _actionType),
        );
      },
    );
  }

  void dispose() {
    _onNewStateSubject.close();
    _onNewActionSubject.close();
    _onAddTaskItemSubject.close();
    _onNewVerticalTaskListStatusSubject.close();
    _onNewHorizontalTaskListStatusSubject.close();
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
