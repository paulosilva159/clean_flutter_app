import 'package:domain/data_observables.dart';
import 'package:domain/use_case/upsert_task_uc.dart';
import 'package:domain/use_case/remove_task_uc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:clean_flutter_app/common/subscription_holder.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';

import 'package:domain/model/task.dart';
import 'package:domain/use_case/get_task_list_uc.dart';

class TaskScreenBloc with SubscriptionHolder {
  TaskScreenBloc({
    @required this.useCases,
    @required this.activeTaskStorageUpdateStreamWrapper,
  })  : assert(useCases != null),
        assert(activeTaskStorageUpdateStreamWrapper != null) {
    getTaskItemListSubject(
      Rx.merge<void>([
        Stream.value(null),
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

    // Rx.merge([
    //   Rx.merge<void>([
    //     Stream.value(null),
    //     _onTryAgainSubject.stream,
    //     activeTaskStorageUpdateStreamWrapper.value,
    //   ]).switchMap<TaskScreenState>((_) => _fetchData()).distinct(),
    //   _onUpsertTaskItemSubject.stream.flatMap<TaskScreenState>(_upsertData),
    //   _onRemoveTaskItemSubject.stream.flatMap<TaskScreenState>(_removeData),
    // ]).distinct().listen(_onNewStateSubject.add).addTo(subscriptions);
  }

  void getTaskItemListSubject(Stream<void> inputStream) => inputStream
      .switchMap<TaskScreenState>((_) => _fetchData())
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  void upsertTaskItemSubject(Stream<Task> inputStream) => inputStream
      .flatMap<TaskScreenState>(_upsertData)
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  void removeTaskItemSubject(Stream<Task> inputStream) => inputStream
      .flatMap<TaskScreenState>(_removeData)
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  final TaskScreenUseCases useCases;
  final ActiveTaskStorageUpdateStreamWrapper
      activeTaskStorageUpdateStreamWrapper;

  final _onTryAgainSubject = PublishSubject<void>();
  final _onUpsertTaskItemSubject = PublishSubject<Task>();
  final _onRemoveTaskItemSubject = PublishSubject<Task>();
  final _onNewStateSubject = BehaviorSubject<TaskScreenState>.seeded(
    Loading(),
  );

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;
  Sink<Task> get onUpsertTaskItem => _onUpsertTaskItemSubject.sink;
  Sink<Task> get onRemoveTaskItem => _onRemoveTaskItemSubject.sink;

  Stream<TaskScreenState> get onNewState => _onNewStateSubject.stream;

  Stream<TaskScreenState> _fetchData() async* {
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

  Stream<TaskScreenState> _upsertData(Task task) async* {
    try {
      await useCases.upsertTask(
        UpsertTaskUCParams(task: task),
      );
    } catch (error) {
      yield Error(error: error);
    }
  }

  Stream<TaskScreenState> _removeData(Task task) async* {
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
    _onUpsertTaskItemSubject.close();
    _onRemoveTaskItemSubject.close();
    disposeSubscriptions();
  }
}

class TaskScreenUseCases {
  TaskScreenUseCases({
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
