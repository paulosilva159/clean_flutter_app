import 'package:clean_flutter_app/presentation/task_screen/task_list_view/task_list_view_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:clean_flutter_app/common/subscription_holder.dart';

import 'package:domain/data_observables.dart';
import 'package:domain/model/task.dart';
import 'package:domain/use_case/get_vertical_task_list_uc.dart';
import 'package:domain/use_case/upsert_task_uc.dart';
import 'package:domain/use_case/remove_task_uc.dart';

class TaskListViewBloc with SubscriptionHolder {
  TaskListViewBloc({
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

    upsertTaskItemSubject(
      _onUpsertTaskItemSubject.stream,
    );

    removeTaskItemSubject(
      _onRemoveTaskItemSubject.stream,
    );
  }

  void getTaskItemListSubject(Stream<void> inputStream) => inputStream
      .switchMap<TaskListViewState>((_) => _fetchData())
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  void upsertTaskItemSubject(Stream<Task> inputStream) => inputStream
      .flatMap<TaskListViewState>(
        (task) => _upsertData(task: task, actionSink: _onNewActionSubject.sink),
      )
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  void removeTaskItemSubject(Stream<Task> inputStream) => inputStream
      .flatMap<TaskListViewState>(
        (task) => _removeData(task: task, actionSink: _onNewActionSubject.sink),
      )
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  final TaskListViewUseCases useCases;
  final ActiveTaskStorageUpdateStreamWrapper
      activeTaskStorageUpdateStreamWrapper;

  final _onTryAgainSubject = PublishSubject<void>();
  final _onNewActionSubject = PublishSubject<TaskScreenAction>();
  final _onUpsertTaskItemSubject = PublishSubject<Task>();
  final _onRemoveTaskItemSubject = PublishSubject<Task>();
  final _onNewStateSubject = BehaviorSubject<TaskListViewState>.seeded(
    Loading(),
  );

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;
  Sink<Task> get onUpsertTaskItem => _onUpsertTaskItemSubject.sink;
  Sink<Task> get onRemoveTaskItem => _onRemoveTaskItemSubject.sink;

  Stream<TaskListViewState> get onNewState => _onNewStateSubject.stream;
  Stream<TaskScreenAction> get onNewAction => _onNewActionSubject.stream;

  Stream<TaskListViewState> _fetchData() async* {
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

  Stream<TaskListViewState> _upsertData({
    @required Task task,
    @required Sink<TaskScreenAction> actionSink,
  }) async* {
    yield Loading();

    try {
      await useCases.upsertTask(
        UpsertTaskUCParams(task: task),
      );
    } catch (error) {
      yield Error(error: error);
    }
  }

  Stream<TaskListViewState> _removeData({
    @required Task task,
    @required Sink<TaskScreenAction> actionSink,
  }) async* {
    yield Loading();

    try {
      await useCases.removeTask(
        RemoveTaskUCParams(task: task),
      );
    } catch (error) {
      yield Error(error: error);
    }
  }

  void dispose() {
    _onTryAgainSubject.close();
    _onNewStateSubject.close();
    _onNewActionSubject.close();
    _onUpsertTaskItemSubject.close();
    _onRemoveTaskItemSubject.close();
    disposeSubscriptions();
  }
}

class TaskListViewUseCases {
  TaskListViewUseCases({
    @required this.getTaskListUC,
    @required this.removeTaskUC,
    @required this.upsertTaskUC,
  })  : assert(getTaskListUC != null),
        assert(removeTaskUC != null),
        assert(upsertTaskUC != null);

  final GetTaskListUC getTaskListUC;
  final RemoveTaskUC removeTaskUC;
  final UpsertTaskUC upsertTaskUC;

  Future<List<Task>> getTasksList() => getTaskListUC.getFuture();

  Future<void> upsertTask(UpsertTaskUCParams params) =>
      upsertTaskUC.getFuture(params: params);

  Future<void> removeTask(RemoveTaskUCParams params) =>
      removeTaskUC.getFuture(params: params);
}
