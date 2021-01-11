import 'package:clean_flutter_app/common/subscription_holder.dart';
import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/vertical_task_list_view_model.dart';
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

class VerticalTaskListViewBloc with SubscriptionHolder {
  VerticalTaskListViewBloc({
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
        .switchMap<VerticalTaskListViewState>(
          (_) => _fetchData(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);
  }

  final VerticalTaskListViewUseCases useCases;
  final ActiveTaskStorageUpdateStreamWrapper
      activeTaskStorageUpdateStreamWrapper;
  final TaskListStatusUpdateCallback onNewTaskListStatus;

  final _onTryAgainSubject = PublishSubject<void>();
  final _onNewActionSubject = PublishSubject<VerticalTaskListAction>();
  final _onUpdateTaskSubject = PublishSubject<Task>();
  final _onRemoveTaskSubject = PublishSubject<Task>();
  final _onNewStateSubject = BehaviorSubject<VerticalTaskListViewState>();

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;
  Sink<Task> get onUpdateTask => _onUpdateTaskSubject.sink;
  Sink<Task> get onRemoveTask => _onRemoveTaskSubject.sink;

  Stream<VerticalTaskListViewState> get onNewState => _onNewStateSubject.stream;
  Stream<VerticalTaskListAction> get onNewAction => _onNewActionSubject.stream;

  Stream<VerticalTaskListViewState> _fetchData() async* {
    yield Loading();

    try {
      final taskList = await useCases.getTasksList().then((list) {
        onNewTaskListStatus(
          TaskListStatus.loaded,
        );

        // TODO(paulosilva159): aplicar ordenação por priority

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
    @required Sink<VerticalTaskListAction> actionSink,
  }) async {
    const _actionType = VerticalTaskListActionType.updateTask;

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
    @required Sink<VerticalTaskListAction> actionSink,
  }) async {
    const _actionType = VerticalTaskListActionType.removeTask;

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

class VerticalTaskListViewUseCases {
  VerticalTaskListViewUseCases({
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
          orientation: TaskListOrientation.vertical,
        ),
      );

  Future<void> updateTask(UpdateTaskUCParams params) =>
      updateTaskUC.getFuture(params: params);

  Future<void> removeTask(RemoveTaskUCParams params) =>
      removeTaskUC.getFuture(params: params);

  Future<void> reorderTasks(ChangeTaskPriorityUCParams params) =>
      changeTaskPriorityUC.getFuture(params: params);
}
