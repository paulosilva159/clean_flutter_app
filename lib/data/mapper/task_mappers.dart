import 'package:clean_flutter_app/data/cache/model/task_cm.dart';
import 'package:clean_flutter_app/data/mapper/task_step_mappers.dart';
import 'package:clean_flutter_app/data/storage_model/task_step_sm.dart';
import 'package:domain/common/task_list_orientation.dart';
import 'package:domain/common/task_priority.dart';
import 'package:domain/common/task_status.dart';
import 'package:domain/model/task.dart';
import 'package:enum_to_string/enum_to_string.dart';

extension CacheToDomain on TaskCM {
  Task toDM() => Task(
        id: id,
        title: title,
        status: EnumToString.fromString(
          TaskStatus.values,
          status,
        ),
        orientation: EnumToString.fromString(
          TaskListOrientation.values,
          orientation,
        ),
        deadline: deadline,
        steps: steps?.map((step) => TaskStepSM.fromJson(step).toDM())?.toList(),
        periodicity: periodicity,
        priority: EnumToString.fromString(
          TaskPriority.values,
          priority,
        ),
        creationTime: creationTime,
      );
}

extension DomainToCache on Task {
  TaskCM toCM() => TaskCM(
        id: id,
        title: title,
        deadline: deadline,
        periodicity: periodicity,
        creationTime: creationTime,
        status: EnumToString.convertToString(status),
        priority: EnumToString.convertToString(priority),
        orientation: EnumToString.convertToString(orientation),
        steps: steps?.map((step) => step.toSM().toJson())?.toList(),
      );
}
