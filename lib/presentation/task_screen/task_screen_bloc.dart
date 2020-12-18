import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:clean_flutter_app/common/subscription_holder.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';

import 'package:domain/model/task.dart';
import 'package:domain/use_case/upsert_task_uc.dart';

class TaskScreenBloc with SubscriptionHolder {
  TaskScreenBloc({
    @required this.useCases,
  }) : assert(useCases != null) {
    upsertTaskItemSubject(_onUpsertTaskItemSubject.stream);

    updateTaskListStatusSubject(_onNewTaskListStatusSubject.stream);
  }

  void upsertTaskItemSubject(Stream<Task> inputStream) => inputStream
      .flatMap<TaskScreenState>(
        (task) => _upsertData(task: task, actionSink: _onNewActionSubject.sink),
      )
      .listen(_onNewStateSubject.add)
      .addTo(subscriptions);

  void updateTaskListStatusSubject(Stream<TaskListStatus> inputStream) =>
      inputStream.listen((taskListStatus) {
        final _lastListingState = _onNewStateSubject.value;

        if (taskListStatus == TaskListStatus.loaded &&
            _lastListingState is! SuccessfullyLoadedList) {
          _onNewStateSubject.add(
            SuccessfullyLoadedList(),
          );
        }
      }).addTo(subscriptions);

  final TaskScreenUseCases useCases;

  final _onNewActionSubject = PublishSubject<TaskScreenAction>();
  final _onUpsertTaskItemSubject = PublishSubject<Task>();
  final _onNewStateSubject = BehaviorSubject<TaskScreenState>.seeded(
    LoadingList(),
  );
  final _onNewTaskListStatusSubject = BehaviorSubject<TaskListStatus>.seeded(
    TaskListStatus.loading,
  );

  Sink<Task> get onUpsertTaskItem => _onUpsertTaskItemSubject.sink;
  Sink<TaskListStatus> get onNewTaskListStatus =>
      _onNewTaskListStatusSubject.sink;

  Stream<TaskScreenState> get onNewState => _onNewStateSubject.stream;
  Stream<TaskScreenAction> get onNewAction => _onNewActionSubject.stream;

  Stream<TaskScreenState> _upsertData({
    @required Task task,
    @required Sink<TaskScreenAction> actionSink,
  }) async* {
    try {
      await useCases.upsertTask(
        UpsertTaskUCParams(task: task),
      );
    } catch (error) {
      yield Error(error: error);
    }
  }

  void dispose() {
    _onNewStateSubject.close();
    _onNewActionSubject.close();
    _onUpsertTaskItemSubject.close();
    _onNewTaskListStatusSubject.close();
    disposeSubscriptions();
  }
}

class TaskScreenUseCases {
  TaskScreenUseCases({
    @required this.upsertTaskUC,
  }) : assert(upsertTaskUC != null);

  final UpsertTaskUC upsertTaskUC;

  Future<void> upsertTask(UpsertTaskUCParams params) =>
      upsertTaskUC.getFuture(params: params);
}
