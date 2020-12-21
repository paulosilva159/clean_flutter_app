import 'package:domain/model/task.dart';

import 'package:clean_flutter_app/data/cache/model/task_cm.dart';
import 'package:enum_to_string/enum_to_string.dart';

extension DomainToCache on Task {
  TaskCM toCM() => TaskCM(
        id: id,
        title: title,
        orientation: EnumToString.convertToString(orientation),
      );
}
