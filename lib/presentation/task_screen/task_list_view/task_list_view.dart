import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:clean_flutter_app/presentation/common/indicator/loading_indicator.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_list_view/task_list_view_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_list_view/task_list_view_model.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_list_view/widgets/task_list.dart';
import 'package:clean_flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:clean_flutter_app/presentation/common/indicator/empty_list_indicator.dart';
import 'package:clean_flutter_app/presentation/common/indicator/error_indicator.dart';

import 'package:domain/data_observables.dart';
import 'package:domain/exceptions.dart';

typedef TaskListStatusUpdateCallback = void Function(TaskListStatus);

class TaskListView extends StatelessWidget {
  const TaskListView({
    @required this.bloc,
    @required this.onNewTaskListStatus,
  })  : assert(bloc != null),
        assert(onNewTaskListStatus != null);

  final TaskListViewBloc bloc;
  final TaskListStatusUpdateCallback onNewTaskListStatus;

  static Widget create(
          {@required TaskListStatusUpdateCallback onNewTaskListStatus}) =>
      ProxyProvider2<ActiveTaskStorageUpdateStreamWrapper, TaskListViewUseCases,
          TaskListViewBloc>(
        update: (
          context,
          activeTaskStorageUpdateStreamWrapper,
          taskListViewUseCases,
          taskListViewBloc,
        ) =>
            taskListViewBloc ??
            TaskListViewBloc(
              activeTaskStorageUpdateStreamWrapper:
                  activeTaskStorageUpdateStreamWrapper,
              useCases: taskListViewUseCases,
            ),
        dispose: (context, bloc) => bloc.dispose(),
        child: Consumer<TaskListViewBloc>(
          builder: (context, bloc, child) => TaskListView(
            bloc: bloc,
            onNewTaskListStatus: onNewTaskListStatus,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => StreamBuilder<Object>(
        stream: bloc.onNewState,
        builder: (context, snapshot) =>
            AsyncSnapshotResponseView<Loading, Error, Success>(
          loadingWidgetBuilder: (context, loading) => LoadingIndicator(),
          errorWidgetBuilder: (context, error) => ErrorIndicator(
            error: error,
            onTryAgainTap: () => bloc.onTryAgain.add(null),
          ),
          successWidgetBuilder: (context, success) {
            onNewTaskListStatus(TaskListStatus.loaded);

            if (success is Listing) {
              return TaskList(
                onRemoveTask: bloc.onRemoveTaskItem.add,
                onUpdateTask: bloc.onUpsertTaskItem.add,
                tasks: success.tasks,
              );
            } else if (success is Empty) {
              return EmptyListIndicator();
            }

            throw UnkownStateException();
          },
          snapshot: snapshot,
        ),
      );
}
