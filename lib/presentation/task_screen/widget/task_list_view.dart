import 'package:flutter/material.dart';

import 'package:clean_flutter_app/presentation/task_screen/widget/task_list_item.dart';
import 'package:domain/model/task.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({@required this.tasks}) : assert(tasks != null);

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (context, index) => TaskListItem(
          task: tasks[index],
        ),
        itemCount: tasks.length,
      );
}
