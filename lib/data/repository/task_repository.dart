import 'package:clean_flutter_app/data/cache/source/task_cds.dart';
import 'package:clean_flutter_app/data/mapper/cache_to_domain.dart';
import 'package:clean_flutter_app/data/mapper/domain_to_cache.dart';
import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/model/task.dart';
import 'package:meta/meta.dart';

class TaskRepository extends TaskDataRepository {
  TaskRepository({@required this.cacheDS}) : assert(cacheDS != null);

  final TaskCDS cacheDS;

  @override
  Future<List<Task>> getTaskList(TaskListOrientation orientation) =>
      (orientation == TaskListOrientation.vertical
              ? cacheDS.getVerticalTaskList()
              : cacheDS.getHorizontalTaskList())
          .then(
        (list) => list.map((task) => task.toDM()).toList(),
      );
  @override
  Future<void> upsertTask(Task task) =>
      task.orientation == TaskListOrientation.vertical
          ? cacheDS.upsertVerticalTask(task.toCM())
          : cacheDS.upsertHorizontalTask(task.toCM());

  @override
  Future<void> removeTask(Task task) =>
      task.orientation == TaskListOrientation.vertical
          ? cacheDS.removeVerticalTask(task.toCM())
          : cacheDS.removeHorizontalTask(task.toCM());

  @override
  Future<void> reorderTask(
    TaskListOrientation orientation, {
    @required int oldId,
    @required int newId,
  }) =>
      orientation == TaskListOrientation.vertical
          ? cacheDS.reorderVerticalTask(oldId, newId)
          : cacheDS.reorderHorizontalTask(oldId, newId);
}
