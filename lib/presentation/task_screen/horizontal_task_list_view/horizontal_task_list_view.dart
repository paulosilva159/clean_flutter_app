import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:clean_flutter_app/presentation/common/action_stream_listener.dart';
import 'package:clean_flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:clean_flutter_app/presentation/common/buttons/delete_task_button.dart';
import 'package:clean_flutter_app/presentation/common/buttons/edit_task_button.dart';
import 'package:clean_flutter_app/presentation/common/indicator/empty_list_indicator.dart';
import 'package:clean_flutter_app/presentation/common/indicator/error_indicator.dart';
import 'package:clean_flutter_app/presentation/common/indicator/loading_indicator.dart';
import 'package:clean_flutter_app/presentation/common/snackbar/task_action_message_snackbar.dart';
import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:clean_flutter_app/presentation/task_screen/horizontal_task_list_view/horizontal_task_list_view_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/horizontal_task_list_view/horizontal_task_list_view_model.dart';
import 'package:domain/data_observables.dart';
import 'package:domain/exceptions.dart';
import 'package:domain/model/task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef TaskListStatusUpdateCallback = void Function(TaskListStatus);

class HorizontalTaskListView extends StatelessWidget {
  HorizontalTaskListView({
    @required this.bloc,
    @required this.onNewTaskListStatus,
  })  : assert(bloc != null),
        assert(onNewTaskListStatus != null);

  final HorizontalTaskListViewBloc bloc;
  final TaskListStatusUpdateCallback onNewTaskListStatus;

  static Widget create(
          {@required TaskListStatusUpdateCallback onNewTaskListStatus}) =>
      ProxyProvider2<ActiveTaskStorageUpdateStreamWrapper,
          HorizontalTaskListViewUseCases, HorizontalTaskListViewBloc>(
        update: (
          context,
          activeTaskStorageUpdateStreamWrapper,
          taskListViewUseCases,
          taskListViewBloc,
        ) =>
            taskListViewBloc ??
            HorizontalTaskListViewBloc(
              activeTaskStorageUpdateStreamWrapper:
                  activeTaskStorageUpdateStreamWrapper,
              useCases: taskListViewUseCases,
            ),
        dispose: (context, bloc) => bloc.dispose(),
        child: Consumer<HorizontalTaskListViewBloc>(
          builder: (context, bloc, child) => HorizontalTaskListView(
            bloc: bloc,
            onNewTaskListStatus: onNewTaskListStatus,
          ),
        ),
      );

  String _snackBarMessage(
    BuildContext context, {
    @required HorizontalTaskListAction action,
  }) {
    if (action is ShowFailTaskAction) {
      switch (action.type) {
        case HorizontalTaskListActionType.updateTask:
          return S.of(context).updateTaskFailSnackBarMessage;
        case HorizontalTaskListActionType.removeTask:
          return S.of(context).removeTaskFailSnackBarMessage;
        case HorizontalTaskListActionType.reorderTask:
          return S.of(context).reorderTasksFailSnackBarMessage;
      }
    } else {
      switch (action.type) {
        case HorizontalTaskListActionType.updateTask:
          return S.of(context).updateTaskSuccessSnackBarMessage;
        case HorizontalTaskListActionType.removeTask:
          return S.of(context).removeTaskSuccessSnackBarMessage;
        case HorizontalTaskListActionType.reorderTask:
          return S.of(context).reorderTaskSuccessSnackBarMessage;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) =>
      ActionStreamListener<HorizontalTaskListAction>(
        actionStream: bloc.onNewAction,
        onReceived: (action) {
          final _message = _snackBarMessage(
            context,
            action: action,
          );

          if (action is ShowFailTaskAction) {
            showFailTask(context, message: _message);
          } else {
            showSuccessTask(context, message: _message);
          }
        },
        child: StreamBuilder<Object>(
          stream: bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            loadingWidgetBuilder: (context, loading) {
              onNewTaskListStatus(
                TaskListLoading(),
              );

              return LoadingIndicator();
            },
            errorWidgetBuilder: (context, error) => ErrorIndicator(
              error: error,
              onTryAgainTap: () => bloc.onTryAgain.add(null),
            ),
            successWidgetBuilder: (context, success) {
              onNewTaskListStatus(
                TaskListLoaded(
                  listSize: success.listSize,
                ),
              );

              if (success is Listing) {
                return _HorizontalTaskList(
                  onRemoveTask: bloc.onRemoveTask.add,
                  onUpdateTask: bloc.onUpdateTask.add,
                  onReorderTasks: (oldId, newId) {
                    bloc.onReorderTask.add(
                      ReorderableTaskIds(oldId: oldId, newId: newId),
                    );
                  },
                  tasks: success.tasks,
                );
              } else if (success is Empty) {
                return EmptyListIndicator();
              }

              throw UnkownStateException();
            },
            snapshot: snapshot,
          ),
        ),
      );
}

class _HorizontalTaskList extends StatefulWidget {
  const _HorizontalTaskList({
    @required this.onRemoveTask,
    @required this.onUpdateTask,
    @required this.onReorderTasks,
    @required this.tasks,
  })  : assert(tasks != null),
        assert(onUpdateTask != null),
        assert(onRemoveTask != null),
        assert(onReorderTasks != null);

  final void Function(Task) onRemoveTask;
  final void Function(Task) onUpdateTask;
  final void Function(int, int) onReorderTasks;
  final List<Task> tasks;

  @override
  __HorizontalTaskListState createState() => __HorizontalTaskListState();
}

class __HorizontalTaskListState extends State<_HorizontalTaskList> {
  bool _isShowingHorizontalTaskDetails = false;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.pink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => _HorizontalTaskItem(
                  task: widget.tasks[index],
                  onRemoveTask: widget.onRemoveTask,
                  onUpdateTask: widget.onUpdateTask,
                ),
                itemCount: widget.tasks.length,
              ),
            ),
            Visibility(
              visible: _isShowingHorizontalTaskDetails,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final _task = widget.tasks[index];

                  return _HorizontalTaskItemDetails(
                    task: _task,
                    onUpdateTask: widget.onUpdateTask,
                    onRemoveTask: widget.onRemoveTask,
                  );
                },
                itemCount: widget.tasks.length,
              ),
            ),
            FlatButton.icon(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _isShowingHorizontalTaskDetails =
                      !_isShowingHorizontalTaskDetails;
                });
              },
              icon: Icon(
                _isShowingHorizontalTaskDetails
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
              ),
              label: Container(),
            ),
          ],
        ),
      );
}

class _HorizontalTaskItem extends StatelessWidget {
  const _HorizontalTaskItem({
    @required this.task,
    @required this.onRemoveTask,
    @required this.onUpdateTask,
    Key key,
  })  : assert(task != null),
        assert(onRemoveTask != null),
        assert(onUpdateTask != null),
        super(key: key);

  final Task task;
  final void Function(Task) onRemoveTask;
  final void Function(Task) onUpdateTask;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.amber,
        ),
        height: 100,
        width: 100,
        child: Center(
          child: Text('${task.id}'),
        ),
      );
}

class _HorizontalTaskItemDetails extends StatelessWidget {
  const _HorizontalTaskItemDetails({
    @required this.task,
    @required this.onRemoveTask,
    @required this.onUpdateTask,
  })  : assert(task != null),
        assert(onRemoveTask != null),
        assert(onUpdateTask != null);

  final void Function(Task) onRemoveTask;
  final void Function(Task) onUpdateTask;
  final Task task;

  static const _denseIconSize = 20.0;

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        leading: Text('#${task.id}'),
        title: Text(
          task.title,
          style: const TextStyle(fontSize: 16.5),
        ),
        trailing: Container(
          width: 75,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              EditTaskButton(
                iconSize: _denseIconSize,
                task: task,
                onUpdateTask: onUpdateTask,
              ),
              DeleteTaskButton(
                iconSize: _denseIconSize,
                task: task,
                onRemoveTask: onRemoveTask,
              ),
            ],
          ),
        ),
      );
}
