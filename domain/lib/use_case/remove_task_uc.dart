import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/task_data_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/model/task.dart';
import 'package:domain/use_case/use_case.dart';
import 'package:meta/meta.dart';

class RemoveTaskUC extends UseCase<void, RemoveTaskUCParams> {
  RemoveTaskUC({
    @required this.repository,
    @required ErrorLogger logger,
    @required this.activeTaskStorageUpdateSinkWrapper,
  })  : assert(repository != null),
        assert(activeTaskStorageUpdateSinkWrapper != null),
        super(logger: logger);

  final TaskDataRepository repository;
  final ActiveTaskStorageUpdateSinkWrapper activeTaskStorageUpdateSinkWrapper;

  @override
  Future<void> getRawFuture({RemoveTaskUCParams params}) =>
      repository.removeTask(params.task).then(
            (_) => activeTaskStorageUpdateSinkWrapper.value.add(null),
          );
}

class RemoveTaskUCParams {
  RemoveTaskUCParams({
    @required this.task,
  }) : assert(task != null);

  final Task task;
}
