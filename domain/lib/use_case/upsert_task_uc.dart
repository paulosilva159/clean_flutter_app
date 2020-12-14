import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/model/task.dart';
import 'package:meta/meta.dart';
import 'package:domain/use_case/use_case.dart';

class UpsertTaskUC extends UseCase<void, UpsertTaskUCParams> {
  UpsertTaskUC({
    @required this.repository,
    @required ErrorLogger logger,
    @required this.activeTaskStorageUpdateSinkWrapper,
  })  : assert(repository != null),
        assert(activeTaskStorageUpdateSinkWrapper != null),
        super(logger: logger);

  final TaskDataRepository repository;
  final ActiveTaskStorageUpdateSinkWrapper activeTaskStorageUpdateSinkWrapper;

  @override
  Future<void> getRawFuture({UpsertTaskUCParams params}) => repository
      .upsertTask(params.task)
      .then((_) => activeTaskStorageUpdateSinkWrapper.value.add(null));
}

class UpsertTaskUCParams {
  UpsertTaskUCParams({@required this.task}) : assert(task != null);

  final Task task;
}
