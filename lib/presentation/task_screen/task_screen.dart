import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/upsert_task_form_dialog.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_list_view/task_list_view.dart';

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

  @override
  Widget build(BuildContext context) => StreamBuilder<TaskScreenState>(
        stream: bloc.onNewState,
        builder: (context, snapshot) {
          final screenState = snapshot.data;

          return Scaffold(
            resizeToAvoidBottomPadding: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: screenState is Success
                ? FloatingActionButton(
                    onPressed: () {
                      showUpsertTaskFormDialog(
                        context,
                        formDialogTitle: 'add',
                        onUpsertTask: bloc.onUpsertTaskItem.add,
                      );
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
            body: Column(
              children: [
                TaskListView.create(),
              ],
            ),
          );
        },
      );
}
