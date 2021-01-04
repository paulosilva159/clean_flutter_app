import 'package:clean_flutter_app/data/cache/model/task_cm.dart';
import 'package:clean_flutter_app/data/mapper/storage_to_domain.dart';
import 'package:clean_flutter_app/data/storage_model/task_step_sm.dart';
import 'package:domain/model/task.dart';
import 'package:domain/model/task_list_orientation.dart';
import 'package:domain/model/task_status.dart';
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
        days: days,
        steps: steps
            .map(
              (step) => TaskStepSM.fromJson(step).toDM(),
            )
            .toList(),
        periodicity: periodicity,
        progress: progress,
      );
}
