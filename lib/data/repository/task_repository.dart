import 'package:meta/meta.dart';

import 'package:clean_flutter_app/data/cache/source/task_cds.dart';
import 'package:clean_flutter_app/data/mapper/cache_to_domain.dart';

import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/model/task.dart';

class TaskRepository extends TaskDataRepository {
  TaskRepository({@required this.taskCDS}) : assert(taskCDS != null);

  final TaskCDS taskCDS;

  @override
  Future<List<Task>> getTaskList() => taskCDS.getTaskList().then(
        (list) => list.map((task) => task.toDM()).toList(),
      );

  @override
  Future<void> addTask(Task task) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<void> removeTask(Task task) {
    // TODO: implement removeTask
    throw UnimplementedError();
  }
}
