import 'package:clean_flutter_app/common/subscription_holder.dart';
import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/vertical_task_list_view_model.dart';
import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/model/task.dart';
import 'package:domain/use_case/get_task_list_uc.dart';
import 'package:domain/use_case/remove_task_uc.dart';
import 'package:domain/use_case/reorder_task_uc.dart';
import 'package:domain/use_case/update_task_uc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class VerticalTaskListViewBloc with SubscriptionHolder {
  VerticalTaskListViewBloc({
    @required this.useCases,
    @required this.activeTaskStorageUpdateStreamWrapper,
  })  : assert(useCases != null),
        assert(activeTaskStorageUpdateStreamWrapper != null) {
    Rx.merge<VerticalTaskListViewState>([
      getTaskListSubject(
        Rx.merge<void>([
          Stream<void>.value(null),
          _onTryAgainSubject.stream,
          activeTaskStorageUpdateStreamWrapper.value,
        ]),
      ),
      updateTaskSubject(
        _onUpdateTaskSubject.stream,
      ),
      removeTaskSubject(
        _onRemoveTaskSubject.stream,
      ),
      reorderTaskSubject(
        _onReorderTaskSubject.stream,
      ),
    ]).listen(_onNewStateSubject.add).addTo(subscriptions);
  }

  Stream<VerticalTaskListViewState> getTaskListSubject(
          Stream<void> inputStream) =>
      inputStream.switchMap<VerticalTaskListViewState>(
        (_) => _fetchData(),
      );

  Stream<VerticalTaskListViewState> updateTaskSubject(
          Stream<Task> inputStream) =>
      inputStream.flatMap<VerticalTaskListViewState>(
        (task) => _updateData(
          task: task,
          actionSink: _onNewActionSubject.sink,
        ),
      );

  Stream<VerticalTaskListViewState> removeTaskSubject(
          Stream<Task> inputStream) =>
      inputStream.flatMap<VerticalTaskListViewState>(
        (task) => _removeData(
          task: task,
          actionSink: _onNewActionSubject.sink,
        ),
      );

  Stream<VerticalTaskListViewState> reorderTaskSubject(
          Stream<ReorderableTaskIds> inputStream) =>
      inputStream.flatMap<VerticalTaskListViewState>(
        (reorderingTaskIds) => _reorderData(
          reorderingTaskIds: reorderingTaskIds,
          actionSink: _onNewActionSubject.sink,
        ),
      );

  final VerticalTaskListViewUseCases useCases;
  final ActiveTaskStorageUpdateStreamWrapper
      activeTaskStorageUpdateStreamWrapper;

  final _onTryAgainSubject = PublishSubject<void>();
  final _onNewActionSubject = PublishSubject<VerticalTaskListAction>();
  final _onUpdateTaskSubject = PublishSubject<Task>();
  final _onRemoveTaskSubject = PublishSubject<Task>();
  final _onReorderTaskSubject = PublishSubject<ReorderableTaskIds>();
  final _onNewStateSubject = BehaviorSubject<VerticalTaskListViewState>();

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;
  Sink<Task> get onUpdateTask => _onUpdateTaskSubject.sink;
  Sink<Task> get onRemoveTask => _onRemoveTaskSubject.sink;
  Sink<ReorderableTaskIds> get onReorderTask => _onReorderTaskSubject.sink;

  Stream<VerticalTaskListViewState> get onNewState => _onNewStateSubject.stream;
  Stream<VerticalTaskListAction> get onNewAction => _onNewActionSubject.stream;

  Stream<VerticalTaskListViewState> _fetchData() async* {
    yield Loading();

    try {
      final taskList = await useCases.getTasksList();

      if (taskList == null || taskList.isEmpty) {
        yield Empty();
      } else {
        yield Listing(tasks: taskList);
      }
    } catch (error) {
      yield Error(error: error);
    }
  }

  Stream<VerticalTaskListViewState> _updateData({
    @required Task task,
    @required Sink<VerticalTaskListAction> actionSink,
  }) async* {
    final _lastListingState = _onNewStateSubject.value;
    const _actionType = VerticalTaskListActionType.updateTask;

    yield Loading();

    try {
      await useCases.updateTask(
        UpdateTaskUCParams(task: task),
      );

      actionSink.add(
        ShowSuccessTaskAction(
          type: _actionType,
        ),
      );
    } catch (error) {
      yield _lastListingState;

      actionSink.add(
        ShowFailTaskAction(
          type: _actionType,
        ),
      );
    }
  }

  Stream<VerticalTaskListViewState> _removeData({
    @required Task task,
    @required Sink<VerticalTaskListAction> actionSink,
  }) async* {
    final _lastListingState = _onNewStateSubject.value;
    const _actionType = VerticalTaskListActionType.removeTask;

    yield Loading();

    try {
      await useCases.removeTask(
        RemoveTaskUCParams(task: task),
      );

      actionSink.add(
        ShowSuccessTaskAction(
          type: _actionType,
        ),
      );
    } catch (error) {
      yield _lastListingState;

      actionSink.add(
        ShowFailTaskAction(
          type: _actionType,
        ),
      );
    }
  }

  Stream<VerticalTaskListViewState> _reorderData({
    @required ReorderableTaskIds reorderingTaskIds,
    @required Sink<VerticalTaskListAction> actionSink,
  }) async* {
    final _lastListingState = _onNewStateSubject.value;
    const _actionType = VerticalTaskListActionType.reorderTask;

    yield Loading();

    try {
      await useCases.reorderTasks(
        ReorderTaskUCParams(
          orientation: TaskListOrientation.vertical,
          oldId: reorderingTaskIds.oldId,
          newId: reorderingTaskIds.newId,
        ),
      );

      actionSink.add(
        ShowSuccessTaskAction(
          type: _actionType,
        ),
      );
    } catch (error) {
      yield _lastListingState;

      actionSink.add(
        ShowFailTaskAction(
          type: _actionType,
        ),
      );
    }
  }

  void dispose() {
    _onTryAgainSubject.close();
    _onNewStateSubject.close();
    _onNewActionSubject.close();
    _onUpdateTaskSubject.close();
    _onRemoveTaskSubject.close();
    _onReorderTaskSubject.close();
    disposeSubscriptions();
  }
}

class VerticalTaskListViewUseCases {
  VerticalTaskListViewUseCases({
    @required this.getTaskListUC,
    @required this.removeTaskUC,
    @required this.updateTaskUC,
    @required this.reorderTasksUC,
  })  : assert(getTaskListUC != null),
        assert(removeTaskUC != null),
        assert(updateTaskUC != null),
        assert(reorderTasksUC != null);

  final GetTaskListUC getTaskListUC;
  final RemoveTaskUC removeTaskUC;
  final UpdateTaskUC updateTaskUC;
  final ReorderTaskUC reorderTasksUC;

  Future<List<Task>> getTasksList() => getTaskListUC.getFuture(
        params: GetTaskListUCParams(
          orientation: TaskListOrientation.vertical,
        ),
      );

  Future<void> updateTask(UpdateTaskUCParams params) =>
      updateTaskUC.getFuture(params: params);

  Future<void> removeTask(RemoveTaskUCParams params) =>
      removeTaskUC.getFuture(params: params);

  Future<void> reorderTasks(ReorderTaskUCParams params) =>
      reorderTasksUC.getFuture(params: params);
}
