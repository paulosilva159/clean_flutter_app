import 'package:meta/meta.dart';

import 'package:domain/model/task.dart';
import 'package:domain/use_case/get_task_list_uc.dart';

class TaskScreenUseCases {
  TaskScreenUseCases({@required this.getTaskListUC})
      : assert(getTaskListUC != null);

  final GetTaskListUC getTaskListUC;

  Future<List<Task>> getTasksList() => getTaskListUC.getFuture();
}
