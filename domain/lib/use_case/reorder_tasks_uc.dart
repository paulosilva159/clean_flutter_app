import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/use_case/use_case.dart';
import 'package:meta/meta.dart';

class ReorderTasksUC extends UseCase<void, ReorderTasksUCParams> {
  ReorderTasksUC({
    @required this.repository,
    @required this.activeTaskStorageUpdateSinkWrapper,
    @required ErrorLogger logger,
  })  : assert(repository != null),
        assert(activeTaskStorageUpdateSinkWrapper != null),
        super(logger: logger);

  final TaskDataRepository repository;
  final ActiveTaskStorageUpdateSinkWrapper activeTaskStorageUpdateSinkWrapper;

  @override
  Future<void> getRawFuture({ReorderTasksUCParams params}) => repository
      .reorderTasks(oldId: params.oldId, newId: params.newId)
      .then((_) => activeTaskStorageUpdateSinkWrapper.value.add(null));
}

class ReorderTasksUCParams {
  ReorderTasksUCParams({@required this.oldId, @required this.newId})
      : assert(oldId != null),
        assert(
          newId != null,
        );

  final int oldId;
  final int newId;
}
