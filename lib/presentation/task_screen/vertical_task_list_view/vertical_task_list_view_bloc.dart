import 'package:clean_flutter_app/common/subscription_holder.dart';
import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/vertical_task_list_view_model.dart';
import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/model/task.dart';
import 'package:domain/use_case/get_vertical_task_list_uc.dart';
import 'package:domain/use_case/remove_task_uc.dart';
import 'package:domain/use_case/reorder_tasks_uc.dart';
import 'package:domain/use_case/update_task_uc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class VerticalTaskListViewBloc with SubscriptionHolder {
  VerticalTaskListViewBloc({
    @required this.useCases,
    @required this.activeTaskStorageUpdateStreamWrapper,
  })  : assert(useCases != null),
        assert(activeTaskStorageUpdateStreamWrapper != null) {
    getTaskItemListSubject(
      Rx.merge<void>([
        Stream<void>.value(null),
        _onTryAgainSubject.stream,
        activeTaskStorageUpdateStreamWrapper.value,
      ]),
    );

    updateTaskSubject(
      _onUpdateTaskSubject.stream,
    );

    removeTaskSubject(
      _onRemoveTaskSubject.stream,
    );

    reorderTasksSubject(
      _onReorderTasksSubject.stream,
    );
  }

  void getTaskItemListSubject(Stream<void> inputStream) => inputStream
      .switchMap<VerticalTaskListViewState>(
        (_) => _fetchData(),
      )
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  void updateTaskSubject(Stream<Task> inputStream) => inputStream
      .flatMap<VerticalTaskListViewState>(
        (task) => _updateData(task: task, actionSink: _onNewActionSubject.sink),
      )
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  void removeTaskSubject(Stream<Task> inputStream) => inputStream
      .flatMap<VerticalTaskListViewState>(
        (task) => _removeData(task: task, actionSink: _onNewActionSubject.sink),
      )
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  void reorderTasksSubject(Stream<ReorderingTaskIds> inputStream) => inputStream
      .flatMap<VerticalTaskListViewState>(
        (reorderingTaskIds) => _reorderData(
          reorderingTaskIds: reorderingTaskIds,
          actionSink: _onNewActionSubject.sink,
        ),
      )
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  final VerticalTaskListViewUseCases useCases;
  final ActiveTaskStorageUpdateStreamWrapper
      activeTaskStorageUpdateStreamWrapper;

  final _onTryAgainSubject = PublishSubject<void>();
  final _onNewActionSubject = PublishSubject<VerticalTaskListAction>();
  final _onUpdateTaskSubject = PublishSubject<Task>();
  final _onRemoveTaskSubject = PublishSubject<Task>();
  final _onReorderTasksSubject = PublishSubject<ReorderingTaskIds>();
  final _onNewStateSubject = BehaviorSubject<VerticalTaskListViewState>.seeded(
    Loading(),
  );

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;
  Sink<Task> get onUpdateTask => _onUpdateTaskSubject.sink;
  Sink<Task> get onRemoveTask => _onRemoveTaskSubject.sink;
  Sink<ReorderingTaskIds> get onReorderTasks => _onReorderTasksSubject.sink;

  Stream<VerticalTaskListViewState> get onNewState => _onNewStateSubject.stream;
  Stream<VerticalTaskListAction> get onNewAction => _onNewActionSubject.stream;

  Stream<VerticalTaskListViewState> _fetchData() async* {
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

    yield Loading();

    try {
      await useCases.updateTask(
        UpdateTaskUCParams(task: task),
      );

      actionSink.add(ShowUpdateTaskAction());
    } catch (error) {
      yield _lastListingState;

      actionSink.add(
        ShowFailTaskAction(),
      );
    }
  }

  Stream<VerticalTaskListViewState> _removeData({
    @required Task task,
    @required Sink<VerticalTaskListAction> actionSink,
  }) async* {
    final _lastListingState = _onNewStateSubject.value;

    yield Loading();

    try {
      await useCases.removeTask(
        RemoveTaskUCParams(task: task),
      );

      actionSink.add(ShowRemoveTaskAction());
    } catch (error) {
      yield _lastListingState;

      actionSink.add(
        ShowFailTaskAction(),
      );
    }
  }

  Stream<VerticalTaskListViewState> _reorderData({
    @required ReorderingTaskIds reorderingTaskIds,
    @required Sink<VerticalTaskListAction> actionSink,
  }) async* {
    final _lastListingState = _onNewStateSubject.value;

    yield Loading();

    try {
      await useCases.reorderTasks(
        ReorderTasksUCParams(
          oldId: reorderingTaskIds.oldId,
          newId: reorderingTaskIds.newId,
        ),
      );

      actionSink.add(ShowReorderTaskAction());
    } catch (error) {
      yield _lastListingState;

      actionSink.add(
        ShowFailTaskAction(),
      );
    }
  }

  void dispose() {
    _onTryAgainSubject.close();
    _onNewStateSubject.close();
    _onNewActionSubject.close();
    _onUpdateTaskSubject.close();
    _onRemoveTaskSubject.close();
    _onReorderTasksSubject.close();
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
  final ReorderTasksUC reorderTasksUC;

  Future<List<Task>> getTasksList() => getTaskListUC.getFuture(
          params: GetTaskListUCParams(
        orientation: TaskListOrientation.vertical,
      ));

  Future<void> updateTask(UpdateTaskUCParams params) =>
      updateTaskUC.getFuture(params: params);

  Future<void> removeTask(RemoveTaskUCParams params) =>
      removeTaskUC.getFuture(params: params);

  Future<void> reorderTasks(ReorderTasksUCParams params) =>
      reorderTasksUC.getFuture(params: params);
}
