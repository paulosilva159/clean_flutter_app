import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/model/task.dart';
import 'package:meta/meta.dart';
import 'package:domain/use_case/use_case.dart';

class AddTaskUC extends UseCase<void, AddTaskUCParams> {
  AddTaskUC({
    @required this.repository,
    @required ErrorLogger logger,
  })  : assert(repository != null),
        super(logger: logger);

  final TaskDataRepository repository;

  @override
  Future<void> getRawFuture({AddTaskUCParams params}) =>
      repository.addTask(params.task);
}

class AddTaskUCParams {
  AddTaskUCParams({@required this.task}) : assert(task != null);

  final Task task;
}
