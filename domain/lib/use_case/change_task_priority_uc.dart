import 'package:domain/common/task_priority.dart';
import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/task_data_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/model/model_method/task_update.dart';
import 'package:domain/model/task.dart';
import 'package:domain/use_case/use_case.dart';
import 'package:meta/meta.dart';

class ChangeTaskPriorityUC extends UseCase<void, ChangeTaskPriorityUCParams> {
  ChangeTaskPriorityUC({
    @required this.repository,
    @required this.activeTaskStorageUpdateSinkWrapper,
    @required ErrorLogger logger,
  })  : assert(repository != null),
        assert(activeTaskStorageUpdateSinkWrapper != null),
        super(logger: logger);

  final TaskDataRepository repository;
  final ActiveTaskStorageUpdateSinkWrapper activeTaskStorageUpdateSinkWrapper;

  @override
  Future<void> getRawFuture({ChangeTaskPriorityUCParams params}) => repository
      .upsertTask(
        params.task.update(newPriority: params.newPriority),
      )
      .then(
        (_) => activeTaskStorageUpdateSinkWrapper.value.add(null),
      );
}

class ChangeTaskPriorityUCParams {
  ChangeTaskPriorityUCParams({
    @required this.task,
    @required this.newPriority,
  })  : assert(task != null),
        assert(newPriority != null);

  final Task task;
  final TaskPriority newPriority;
}
