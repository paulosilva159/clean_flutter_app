import 'package:enum_to_string/enum_to_string.dart';

import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/model/task.dart';

import 'package:clean_flutter_app/data/cache/model/task_cm.dart';

extension CacheToDomain on TaskCM {
  Task toDM() => Task(
        id: id,
        title: title,
        orientation: EnumToString.fromString(
          TaskListOrientation.values,
          orientation,
        ),
      );
}
