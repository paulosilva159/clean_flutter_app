import 'package:flutter/material.dart';

import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';

class TaskScreen extends StatelessWidget {
  final List<Task> tasks = [
    Task(title: 'Task'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => TaskItem(
          task: tasks[index],
        ),
        itemCount: tasks.length,
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      title: Text(
        task.title,
      ),
    );
  }
}
