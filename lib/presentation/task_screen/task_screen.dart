import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:clean_flutter_app/presentation/common/action_stream_listener.dart';
import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/task_action_form_dialog.dart';
import 'package:clean_flutter_app/presentation/common/indicator/loading_indicator.dart';
import 'package:clean_flutter_app/presentation/common/snackbar/task_action_message_snackbar.dart';
import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:clean_flutter_app/presentation/task_screen/horizontal_task_list_view/horizontal_task_list_view.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';
import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/vertical_task_list_view.dart';
import 'package:domain/model/task_list_orientation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({@required this.bloc}) : assert(bloc != null);

  final TaskScreenBloc bloc;

  static Widget create() => ProxyProvider<TaskScreenUseCases, TaskScreenBloc>(
        update: (context, taskScreenUseCases, taskScreenBloc) =>
            taskScreenBloc ?? TaskScreenBloc(useCases: taskScreenUseCases),
        dispose: (context, bloc) => bloc.dispose(),
        child: Consumer<TaskScreenBloc>(
          builder: (context, bloc, child) => TaskScreen(bloc: bloc),
        ),
      );

  String _snackBarMessage(
    BuildContext context, {
    @required TaskScreenAction action,
  }) {
    if (action is ShowFailTaskAction) {
      return S.of(context).addTaskFailSnackBarMessage;
    } else {
      return S.of(context).addTaskSuccessSnackBarMessage;
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<TaskScreenState>(
        stream: bloc.onNewState,
        builder: (context, snapshot) {
          final screenState = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Task List App'),
            ),
            resizeToAvoidBottomPadding: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: screenState is Done
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          showUpsertTaskFormDialog(
                            context,
                            formDialogTitle: S.of(context).addTaskDialogTitle,
                            onUpsertTask: bloc.onAddTaskItem.add,
                            upsertingTaskId: screenState.horizontalListSize + 1,
                            upsertingTaskOrientation:
                                TaskListOrientation.horizontal,
                          );
                        },
                        child: const Icon(Icons.horizontal_split_rounded),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          showUpsertTaskFormDialog(
                            context,
                            formDialogTitle: S.of(context).addTaskDialogTitle,
                            onUpsertTask: bloc.onAddTaskItem.add,
                            upsertingTaskId: screenState.verticalListSize + 1,
                            upsertingTaskOrientation:
                                TaskListOrientation.vertical,
                          );
                        },
                        child: const Icon(Icons.vertical_split_rounded),
                      ),
                    ],
                  )
                : null,
            body: Builder(
              builder: (context) => ActionStreamListener<TaskScreenAction>(
                actionStream: bloc.onNewAction,
                onReceived: (action) {
                  final _message = _snackBarMessage(context, action: action);

                  if (action is ShowFailTaskAction) {
                    showFailTask(context, message: _message);
                  } else {
                    showSuccessTask(context, message: _message);
                  }
                },
                child: snapshot.hasData
                    ? _TaskListsView(
                        onNewHorizontalTaskListStatus:
                            bloc.onNewHorizontalTaskListStatus.add,
                        onNewVerticalTaskListStatus:
                            bloc.onNewVerticalTaskListStatus.add,
                      )
                    : LoadingIndicator(),
              ),
            ),
          );
        },
      );
}

class _TaskListsView extends StatelessWidget {
  const _TaskListsView({
    @required this.onNewHorizontalTaskListStatus,
    @required this.onNewVerticalTaskListStatus,
  })  : assert(onNewHorizontalTaskListStatus != null),
        assert(onNewVerticalTaskListStatus != null);

  final void Function(TaskListStatus) onNewHorizontalTaskListStatus;
  final void Function(TaskListStatus) onNewVerticalTaskListStatus;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TaskListSectionTitle(title: 'Lista Horizontal'),
          Padding(
            padding: const EdgeInsets.all(15),
            child: HorizontalTaskListView.create(
              onNewTaskListStatus: onNewHorizontalTaskListStatus,
            ),
          ),
          const TaskListSectionTitle(title: 'Lista Vertical'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: VerticalTaskListView.create(
                onNewTaskListStatus: onNewVerticalTaskListStatus,
              ),
            ),
          ),
        ],
      );
}

class TaskListSectionTitle extends StatelessWidget {
  const TaskListSectionTitle({
    @required this.title,
  }) : assert(title != null);

  final String title;

  @override
  Widget build(BuildContext context) => Container(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
