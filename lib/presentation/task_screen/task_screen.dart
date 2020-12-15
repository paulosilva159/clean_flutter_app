import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:domain/data_observables.dart';

import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/adaptive_form_dialog.dart';
import 'package:clean_flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:clean_flutter_app/presentation/common/indicator/empty_list_indicator.dart';
import 'package:clean_flutter_app/presentation/common/indicator/error_indicator.dart';
import 'package:clean_flutter_app/presentation/common/indicator/loading_indicator.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';
import 'package:clean_flutter_app/presentation/task_screen/widget/task_list_view.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({@required this.bloc}) : assert(bloc != null);

  final TaskScreenBloc bloc;

  static Widget create() => ProxyProvider2<ActiveTaskStorageUpdateStreamWrapper,
          TaskScreenUseCases, TaskScreenBloc>(
        update: (
          context,
          activeTaskStorageUpdateStreamWrapper,
          taskScreenUseCases,
          taskScreenBloc,
        ) =>
            taskScreenBloc ??
            TaskScreenBloc(
              activeTaskStorageUpdateStreamWrapper:
                  activeTaskStorageUpdateStreamWrapper,
              useCases: taskScreenUseCases,
            ),
        dispose: (context, bloc) => bloc.dispose(),
        child: Consumer<TaskScreenBloc>(
          builder: (context, bloc, child) => TaskScreen(bloc: bloc),
        ),
      );

  @override
  Widget build(BuildContext context) => StreamBuilder<TaskScreenState>(
        stream: bloc.onNewState,
        builder: (context, snapshot) {
          final screenState = snapshot.data;

          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: screenState is Success
                ? FloatingActionButton(onPressed: () {
                    AdaptiveFormDialog(
                      formDialogTitle: 'title',
                      formDialogMessage: 'message',
                      onUpsertTask: bloc.onUpsertTaskItem.add,
                      child: Container(),
                    ).show(context);
                  })
                : null,
            body: AsyncSnapshotResponseView<Loading, Error, Success>(
              snapshot: snapshot,
              loadingWidgetBuilder: (context, loading) => LoadingIndicator(),
              errorWidgetBuilder: (context, error) => ErrorIndicator(
                error: error,
                onTryAgainTap: () => bloc.onTryAgain.add(null),
              ),
              successWidgetBuilder: (context, success) {
                if (success is Listing) {
                  return TaskListView(
                    tasks: success.tasks,
                    onRemoveTaskItem: bloc.onRemoveTaskItem.add,
                    onUpdateTaskItem: bloc.onUpsertTaskItem.add,
                  );
                } else {
                  return EmptyListIndicator();
                }
              },
            ),
          );
        },
      );
}
