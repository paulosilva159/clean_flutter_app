import 'dart:async';

import 'package:clean_flutter_app/data/cache/model/task_cm.dart';
import 'package:hive/hive.dart';

class TaskCDS {
  static const String _taskListBoxName = '_taskListBoxName';

  Future<List<TaskCM>> getTaskList() =>
      Hive.openBox<TaskCM>(_taskListBoxName).then<List<TaskCM>>(
        (box) => box.values.toList(),
      );
}
