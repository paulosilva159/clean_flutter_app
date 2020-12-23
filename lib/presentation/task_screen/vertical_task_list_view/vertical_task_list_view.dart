import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:clean_flutter_app/presentation/common/action_stream_listener.dart';
import 'package:clean_flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:clean_flutter_app/presentation/common/indicator/empty_list_indicator.dart';
import 'package:clean_flutter_app/presentation/common/indicator/error_indicator.dart';
import 'package:clean_flutter_app/presentation/common/indicator/loading_indicator.dart';
import 'package:clean_flutter_app/presentation/common/snackbar/task_action_snackbar.dart';
import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/vertical_task_list_view_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/vertical_task_list_view_model.dart';
import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/widgets/task_list.dart';
import 'package:domain/data_observables.dart';
import 'package:domain/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef TaskListStatusUpdateCallback = void Function(TaskListStatus);

class VerticalTaskListView extends StatelessWidget {
  const VerticalTaskListView({
    @required this.bloc,
    @required this.onNewTaskListStatus,
  })  : assert(bloc != null),
        assert(onNewTaskListStatus != null);

  final VerticalTaskListViewBloc bloc;
  final TaskListStatusUpdateCallback onNewTaskListStatus;

  static Widget create(
          {@required TaskListStatusUpdateCallback onNewTaskListStatus}) =>
      ProxyProvider2<ActiveTaskStorageUpdateStreamWrapper,
          VerticalTaskListViewUseCases, VerticalTaskListViewBloc>(
        update: (
          context,
          activeTaskStorageUpdateStreamWrapper,
          taskListViewUseCases,
          taskListViewBloc,
        ) =>
            taskListViewBloc ??
            VerticalTaskListViewBloc(
              activeTaskStorageUpdateStreamWrapper:
                  activeTaskStorageUpdateStreamWrapper,
              useCases: taskListViewUseCases,
            ),
        dispose: (context, bloc) => bloc.dispose(),
        child: Consumer<VerticalTaskListViewBloc>(
          builder: (context, bloc, child) => VerticalTaskListView(
            bloc: bloc,
            onNewTaskListStatus: onNewTaskListStatus,
          ),
        ),
      );

  String _snackBarFailMessage(
    BuildContext context,
    VerticalTaskListActionType actionType,
  ) {
    if (actionType is UpdateTaskAction) {
      return S.of(context).updateTaskFailSnackBarMessage;
    } else if (actionType is RemoveTaskAction) {
      return S.of(context).removeTaskFailSnackBarMessage;
    } else if (actionType is ReorderTaskAction) {
      return S.of(context).reorderTasksFailSnackBarMessage;
    }

    return null;
  }

  String _snackBarSuccessMessage(
    BuildContext context,
    VerticalTaskListActionType actionType,
  ) {
    if (actionType is UpdateTaskAction) {
      return S.of(context).updateTaskSuccessSnackBarMessage;
    } else if (actionType is RemoveTaskAction) {
      return S.of(context).removeTaskSuccessSnackBarMessage;
    } else if (actionType is ReorderTaskAction) {
      return S.of(context).reorderTasksSuccessSnackBarMessage;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) =>
      ActionStreamListener<VerticalTaskListAction>(
        actionStream: bloc.onNewAction,
        onReceived: (action) {
          if (action is ShowFailTaskAction) {
            showFailTask(
              context,
              message: _snackBarFailMessage(
                context,
                action.actionType,
              ),
            );
          } else {
            showSuccessTask(
              context,
              message: _snackBarSuccessMessage(
                context,
                action.actionType,
              ),
            );
          }
        },
        child: StreamBuilder<Object>(
          stream: bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            loadingWidgetBuilder: (context, loading) => LoadingIndicator(),
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
                return TaskList(
                  onRemoveTask: bloc.onRemoveTask.add,
                  onUpdateTask: bloc.onUpdateTask.add,
                  onReorderTasks: (oldId, newId) {
                    bloc.onReorderTasks.add(
                      ReorderingTaskIds(oldId: oldId, newId: newId),
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
