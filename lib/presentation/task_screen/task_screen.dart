import 'package:clean_flutter_app/common/async_snapshot_response_view.dart';
import 'package:clean_flutter_app/common/indicator/empty_list_indicator.dart';
import 'package:clean_flutter_app/common/indicator/error_indicator.dart';
import 'package:clean_flutter_app/common/indicator/loading_indicator.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';
import 'package:flutter/material.dart';

import 'package:clean_flutter_app/presentation/task_screen/widget/task_list_item.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({
    @required this.bloc,
  }) : assert(bloc != null);

  final TaskScreenBloc bloc;

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
        ),
        body: StreamBuilder<TaskScreenState>(
          stream: bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            loadingWidgetBuilder: (context, loading) => LoadingIndicator(),
            errorWidgetBuilder: (context, error) => ErrorIndicator(
              error: error,
              onTryAgainTap: () => bloc.onTryAgain.add(null),
            ),
            successWidgetBuilder: (context, success) {
              if (success is Listing) {
                return ListView.builder(
                  itemBuilder: (context, index) => TaskListItem(
                    task: success.tasks[index],
                  ),
                  itemCount: success.tasks.length,
                );
              } else {
                return EmptyListIndicator();
              }
            },
          ),
        ),
      );
}
