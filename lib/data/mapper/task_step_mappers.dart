import 'package:clean_flutter_app/data/storage_model/task_step_sm.dart';
import 'package:domain/model/task_step.dart';

extension DomainToStorage on TaskStep {
  TaskStepSM toSM() => TaskStepSM(
        id: id,
        title: title,
        status: status,
      );
}

extension StorageToDomain on TaskStepSM {
  TaskStep toDM() => TaskStep(
        id: id,
        title: title,
        status: status,
      );
}
