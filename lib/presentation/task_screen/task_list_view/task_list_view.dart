import 'package:clean_flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/upsert_task_form_dialog.dart';
import 'package:clean_flutter_app/presentation/common/indicator/empty_list_indicator.dart';
import 'package:clean_flutter_app/presentation/common/indicator/error_indicator.dart';
import 'package:clean_flutter_app/presentation/common/indicator/loading_indicator.dart';
import 'package:clean_flutter_app/presentation/task_screen/widget/task_list_view_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/widget/task_list_view_model.dart';
import 'package:domain/data_observables.dart';
import 'package:domain/exceptions.dart';
import 'package:flutter/material.dart';

import 'package:domain/model/task.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({
    @required this.bloc,
  }) : assert(bloc != null);

  final TaskListViewBloc bloc;

  static Widget create() => ProxyProvider2<ActiveTaskStorageUpdateStreamWrapper,
          TaskListViewUseCases, TaskListViewBloc>(
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
          builder: (context, bloc, child) => TaskListView(bloc: bloc),
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
            if (success is Listing) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => _TaskListItem(
                        onRemoveTask: bloc.onRemoveTaskItem.add,
                        onUpdateTask: bloc.onUpsertTaskItem.add,
                        task: success.tasks[index],
                      ),
                      itemCount: success.tasks.length,
                    ),
                  ),
                  AddTaskButton(),
                ],
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

class AddTaskButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton.icon(
        onPressed: () {},
        icon: Icon(
          Icons.add,
          color: Colors.pink,
        ),
        label: Text('aaaa'),
      );
}

class _TaskListItem extends StatelessWidget {
  const _TaskListItem({
    @required this.task,
    @required this.onRemoveTask,
    @required this.onUpdateTask,
  })  : assert(task != null),
        assert(onRemoveTask != null),
        assert(onUpdateTask != null);

  final Task task;
  final void Function(Task) onRemoveTask;
  final void Function(Task) onUpdateTask;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Text('#${task.id}'),
        title: Text(task.title),
        trailing: Container(
          width: 75,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    showUpsertTaskFormDialog(
                      context,
                      formDialogTitle: 'update',
                      onUpsertTask: onUpdateTask,
                      upsertingTask: task,
                    );
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.remove_circle_rounded),
                  onPressed: () => onRemoveTask(task),
                ),
              ),
            ],
          ),
        ),
      );
}
