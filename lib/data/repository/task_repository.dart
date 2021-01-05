import 'package:clean_flutter_app/data/cache/source/task_cds.dart';
import 'package:clean_flutter_app/data/mapper/task_mappers.dart';
import 'package:domain/common/task_list_orientation.dart';
import 'package:domain/data_repository/task_data_repository.dart';
import 'package:domain/model/task.dart';
import 'package:meta/meta.dart';

class TaskRepository extends TaskDataRepository {
  TaskRepository({@required this.cacheDS}) : assert(cacheDS != null);

  final TaskCDS cacheDS;

  @override
  Future<List<Task>> getTaskList(TaskListOrientation orientation) =>
      cacheDS.getTaskList(orientation).then(
            (list) => list
                .map(
                  (task) => task.toDM(),
                )
                .toList(),
          );

  @override
  Future<void> upsertTask(Task task) => cacheDS.upsertTask(
        task.toCM(),
      );

  @override
  Future<void> removeTask(Task task) => cacheDS.removeTask(
        task.toCM(),
      );
}
