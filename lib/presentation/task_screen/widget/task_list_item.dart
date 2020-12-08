import 'package:flutter/material.dart';

import 'package:domain/model/task.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    @required this.task,
    Key key,
  })  : assert(task != null),
        super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) => ListTile(
        key: key,
        title: Text(
          task.title,
        ),
      );
}
