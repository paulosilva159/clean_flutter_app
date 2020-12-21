import 'package:domain/logger.dart';
import 'package:meta/meta.dart';

import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/model/task.dart';
import 'package:domain/use_case/use_case.dart';

class GetTaskListUC extends UseCase<List<Task>, GetTaskListUCParams> {
  GetTaskListUC({
    @required this.repository,
    @required ErrorLogger logger,
  })  : assert(repository != null),
        super(logger: logger);

  final TaskDataRepository repository;

  @override
  Future<List<Task>> getRawFuture({GetTaskListUCParams params}) =>
      repository.getTaskList(orientation: params.orientation);
}

class GetTaskListUCParams {
  GetTaskListUCParams({
    @required this.orientation,
  }) : assert(orientation != null);

  final TaskListOrientation orientation;
}
