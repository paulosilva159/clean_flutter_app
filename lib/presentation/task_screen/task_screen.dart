import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:clean_flutter_app/presentation/common/action_stream_listener.dart';
import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/task_action_form_dialog.dart';
import 'package:clean_flutter_app/presentation/common/indicator/loading_indicator.dart';
import 'package:clean_flutter_app/presentation/common/snackbar/task_action_snackbar.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';
import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/vertical_task_list_view.dart';
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
            resizeToAvoidBottomPadding: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: screenState is Done
                ? FloatingActionButton(
                    onPressed: () {
                      showUpsertTaskFormDialog(
                        context,
                        formDialogTitle: S.of(context).addTaskDialogTitle,
                        onUpsertTask: bloc.onAddTaskItem.add,
                        upsertingTaskId: screenState.listSize + 1,
                      );
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
            body: Builder(
              builder: (context) => ActionStreamListener<TaskScreenAction>(
                actionStream: bloc.onNewAction,
                onReceived: (action) {
                  final _message = _snackBarMessage(
                    context,
                    action: action,
                  );

                  if (action is ShowFailTaskAction) {
                    showFailTask(
                      context,
                      message: _message,
                    );
                  } else {
                    showSuccessTask(
                      context,
                      message: _message,
                    );
                  }
                },
                child: snapshot.hasData
                    ? Column(
                        children: [
                          Expanded(
                            child: VerticalTaskListView.create(
                              onNewTaskListStatus: bloc.onNewTaskListStatus.add,
                            ),
                          ),
                        ],
                      )
                    : LoadingIndicator(),
              ),
            ),
          );
        },
      );
}
