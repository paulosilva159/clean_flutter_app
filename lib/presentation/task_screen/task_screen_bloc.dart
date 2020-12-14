import 'package:domain/data_observables.dart';
import 'package:domain/use_case/add_task_uc.dart';
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
    updateNewStateSubject(
      Rx.merge([
        Stream.value(null),
        _onTryAgainSubject.stream,
      ]),
    );
  }

  void updateNewStateSubject(Stream inputStream) => inputStream
      .flatMap((_) => _fetchData())
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  final TaskScreenUseCases useCases;
  final ActiveTaskStorageUpdateStreamWrapper
      activeTaskStorageUpdateStreamWrapper;

  final _onTryAgainSubject = PublishSubject<void>();
  final _onNewStateSubject = BehaviorSubject<TaskScreenState>.seeded(
    Loading(),
  );

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

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

  // Stream<TaskScreenState> _upsertData(Task task) async* {
  //   final currentState = _onNewStateSubject.value;
  // }
  //
  // Stream<TaskScreenState> _deleteData(Task task) async* {}

  void dispose() {
    _onTryAgainSubject.close();
    _onNewStateSubject.close();
    disposeSubscriptions();
  }
}

class TaskScreenUseCases {
  TaskScreenUseCases({
    @required this.getTaskListUC,
    @required this.removeTaskUC,
    @required this.addTaskUC,
  })  : assert(getTaskListUC != null),
        assert(removeTaskUC != null),
        assert(addTaskUC != null);

  final GetTaskListUC getTaskListUC;
  final RemoveTaskUC removeTaskUC;
  final AddTaskUC addTaskUC;

  Future<List<Task>> getTasksList() => getTaskListUC.getFuture();

  Future<void> addTask(AddTaskUCParams params) =>
      addTaskUC.getFuture(params: params);

  Future<void> removeTask(RemoveTaskUCParams params) =>
      removeTaskUC.getFuture(params: params);
}
