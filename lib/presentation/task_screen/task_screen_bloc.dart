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
    addTaskItemSubject(
      _onAddTaskItemSubject.stream,
    ).listen(_onNewStateSubject.add).addTo(subscriptions);

    updateTaskListStatusSubject(
      _onNewVerticalTaskListStatusSubject.stream,
      _onNewHorizontalTaskListStatusSubject.stream,
    ).distinct().listen((combinedTaskListStatus) {
      final _verticalListStatus = combinedTaskListStatus.verticalListStatus;
      final _horizontalListStatus = combinedTaskListStatus.horizontalListStatus;
      final _listingState = _onNewStateSubject.value;

      if (_verticalListStatus is TaskListLoaded &&
          _horizontalListStatus is TaskListLoaded) {
        final _isInitialListingState = _listingState is! Done;

        final _listsSizeHaveChanged = _listingState is Done &&
            (_listingState.verticalListSize != _verticalListStatus.listSize ||
                _listingState.horizontalListSize !=
                    _horizontalListStatus.listSize);

        if (_isInitialListingState || _listsSizeHaveChanged) {
          _onNewStateSubject.add(
            Done(
              verticalListSize: _verticalListStatus.listSize,
              horizontalListSize: _horizontalListStatus.listSize,
            ),
          );
        }
      }
    }).addTo(subscriptions);
  }

  Stream<TaskScreenState> addTaskItemSubject(Stream<Task> inputStream) =>
      inputStream.flatMap<TaskScreenState>(
        (task) => _addData(task: task, actionSink: _onNewActionSubject.sink),
      );

  Stream<CombinedTaskListStatus> updateTaskListStatusSubject(
    Stream<TaskListStatus> verticalListInputStream,
    Stream<TaskListStatus> horizontalListInputStream,
  ) =>
      Rx.combineLatest2<TaskListStatus, TaskListStatus, CombinedTaskListStatus>(
        verticalListInputStream,
        horizontalListInputStream,
        (verticalListStatus, horizontalListStatus) => CombinedTaskListStatus(
          verticalListStatus: verticalListStatus,
          horizontalListStatus: horizontalListStatus,
        ),
      );

  final TaskScreenUseCases useCases;

  final _onNewActionSubject = PublishSubject<TaskScreenAction>();
  final _onAddTaskItemSubject = PublishSubject<Task>();
  final _onNewStateSubject = BehaviorSubject<TaskScreenState>.seeded(
    Waiting(),
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

  Stream<TaskScreenState> get onNewState => _onNewStateSubject.stream;
  Stream<TaskScreenAction> get onNewAction => _onNewActionSubject.stream;

  Stream<TaskScreenState> _addData({
    @required Task task,
    @required Sink<TaskScreenAction> actionSink,
  }) async* {
    const _actionType = TaskScreenActionType.addTask;

    try {
      await useCases.addTask(
        AddTaskUCParams(task: task),
      );

      actionSink.add(
        ShowSuccessTaskAction(type: _actionType),
      );
    } catch (error) {
      print(error);

      actionSink.add(
        ShowFailTaskAction(type: _actionType),
      );
    }
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
