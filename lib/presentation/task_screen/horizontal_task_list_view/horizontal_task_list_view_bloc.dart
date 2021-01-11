import 'package:clean_flutter_app/common/subscription_holder.dart';
import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:clean_flutter_app/presentation/task_screen/horizontal_task_list_view/horizontal_task_list_view_model.dart';
import 'package:domain/common/task_list_orientation.dart';
import 'package:domain/data_observables.dart';
import 'package:domain/model/task.dart';
import 'package:domain/use_case/change_task_priority_uc.dart';
import 'package:domain/use_case/get_task_list_uc.dart';
import 'package:domain/use_case/remove_task_uc.dart';
import 'package:domain/use_case/update_task_uc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

typedef TaskListStatusUpdateCallback = void Function(TaskListStatus);

class HorizontalTaskListViewBloc with SubscriptionHolder {
  HorizontalTaskListViewBloc({
    @required this.useCases,
    @required this.activeTaskStorageUpdateStreamWrapper,
    @required this.onNewTaskListStatus,
  })  : assert(useCases != null),
        assert(activeTaskStorageUpdateStreamWrapper != null),
        assert(onNewTaskListStatus != null) {
    _onUpdateTaskSubject.stream
        .listen(
          (task) => _updateData(
            task: task,
            actionSink: _onNewActionSubject.sink,
          ),
        )
        .addTo(subscriptions);

    _onRemoveTaskSubject.stream
        .listen(
          (task) => _removeData(
            task: task,
            actionSink: _onNewActionSubject.sink,
          ),
        )
        .addTo(subscriptions);

    Rx.merge<void>([
      Stream<void>.value(null),
      _onTryAgainSubject.stream,
      activeTaskStorageUpdateStreamWrapper.value,
    ])
        .switchMap<HorizontalTaskListViewState>(
          (_) => _fetchData(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);
  }

  final HorizontalTaskListViewUseCases useCases;
  final ActiveTaskStorageUpdateStreamWrapper
      activeTaskStorageUpdateStreamWrapper;
  final TaskListStatusUpdateCallback onNewTaskListStatus;

  final _onTryAgainSubject = PublishSubject<void>();
  final _onNewActionSubject = PublishSubject<HorizontalTaskListAction>();
  final _onUpdateTaskSubject = PublishSubject<Task>();
  final _onRemoveTaskSubject = PublishSubject<Task>();
  final _onNewStateSubject = BehaviorSubject<HorizontalTaskListViewState>();

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;
  Sink<Task> get onUpdateTask => _onUpdateTaskSubject.sink;
  Sink<Task> get onRemoveTask => _onRemoveTaskSubject.sink;

  Stream<HorizontalTaskListViewState> get onNewState =>
      _onNewStateSubject.stream;
  Stream<HorizontalTaskListAction> get onNewAction =>
      _onNewActionSubject.stream;

  Stream<HorizontalTaskListViewState> _fetchData() async* {
    yield Loading();

    try {
      final taskList = await useCases.getTasksList().then((list) {
        onNewTaskListStatus(
          TaskListLoaded(),
        );

        return list
          ..sort(
            (a, b) => a.creationTime.compareTo(b.creationTime),
          );
      });

      if (taskList == null || taskList.isEmpty) {
        yield Empty();
      } else {
        yield Listing(tasks: taskList);
      }
    } catch (error) {
      yield Error(error: error);
    }
  }

  Future<void> _updateData({
    @required Task task,
    @required Sink<HorizontalTaskListAction> actionSink,
  }) async {
    const _actionType = HorizontalTaskListActionType.updateTask;

    await useCases
        .updateTask(
          UpdateTaskUCParams(task: task),
        )
        .then(
          (_) => actionSink.add(
            ShowSuccessTaskAction(
              type: _actionType,
            ),
          ),
        )
        .catchError(
          (error) => actionSink.add(
            ShowFailTaskAction(
              type: _actionType,
            ),
          ),
        );
  }

  Future<void> _removeData({
    @required Task task,
    @required Sink<HorizontalTaskListAction> actionSink,
  }) async {
    const _actionType = HorizontalTaskListActionType.updateTask;

    await useCases
        .removeTask(
          RemoveTaskUCParams(task: task),
        )
        .then(
          (_) => actionSink.add(
            ShowSuccessTaskAction(
              type: _actionType,
            ),
          ),
        )
        .catchError(
          (error) => actionSink.add(
            ShowFailTaskAction(
              type: _actionType,
            ),
          ),
        );
  }

  void dispose() {
    _onTryAgainSubject.close();
    _onNewStateSubject.close();
    _onNewActionSubject.close();
    _onUpdateTaskSubject.close();
    _onRemoveTaskSubject.close();
    disposeSubscriptions();
  }
}

class HorizontalTaskListViewUseCases {
  HorizontalTaskListViewUseCases({
    @required this.getTaskListUC,
    @required this.removeTaskUC,
    @required this.updateTaskUC,
    @required this.changeTaskPriorityUC,
  })  : assert(getTaskListUC != null),
        assert(removeTaskUC != null),
        assert(updateTaskUC != null),
        assert(changeTaskPriorityUC != null);

  final GetTaskListUC getTaskListUC;
  final RemoveTaskUC removeTaskUC;
  final UpdateTaskUC updateTaskUC;
  final ChangeTaskPriorityUC changeTaskPriorityUC;

  Future<List<Task>> getTasksList() => getTaskListUC.getFuture(
        params: GetTaskListUCParams(
          orientation: TaskListOrientation.horizontal,
        ),
      );

  Future<void> updateTask(UpdateTaskUCParams params) =>
      updateTaskUC.getFuture(params: params);

  Future<void> removeTask(RemoveTaskUCParams params) =>
      removeTaskUC.getFuture(params: params);

  Future<void> reorderTasks(ChangeTaskPriorityUCParams params) =>
      changeTaskPriorityUC.getFuture(params: params);
}
