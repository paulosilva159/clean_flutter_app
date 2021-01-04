import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/model/task_list_orientation.dart';
import 'package:domain/use_case/use_case.dart';
import 'package:meta/meta.dart';

class ReorderTaskUC extends UseCase<void, ReorderTaskUCParams> {
  ReorderTaskUC({
    @required this.repository,
    @required this.activeTaskStorageUpdateSinkWrapper,
    @required ErrorLogger logger,
  })  : assert(repository != null),
        assert(activeTaskStorageUpdateSinkWrapper != null),
        super(logger: logger);

  final TaskDataRepository repository;
  final ActiveTaskStorageUpdateSinkWrapper activeTaskStorageUpdateSinkWrapper;

  @override
  Future<void> getRawFuture({ReorderTaskUCParams params}) => repository
      .reorderTask(params.orientation, oldId: params.oldId, newId: params.newId)
      .then(
        (_) => activeTaskStorageUpdateSinkWrapper.value.add(null),
      );
}

class ReorderTaskUCParams {
  ReorderTaskUCParams({
    @required this.orientation,
    @required this.oldId,
    @required this.newId,
  })  : assert(orientation != null),
        assert(oldId != null),
        assert(newId != null);

  final TaskListOrientation orientation;
  final int oldId;
  final int newId;
}
