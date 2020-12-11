import 'package:meta/meta.dart';

import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/model/task.dart';
import 'package:domain/use_case/use_case.dart';

class GetTaskListUC extends UseCase<List<Task>, void> {
  GetTaskListUC({@required this.repository}) : assert(repository != null);

  final TaskDataRepository repository;

  @override
  Future<List<Task>> getRawFuture({void params}) => repository.getTaskList();
}
