import 'package:domain/model/task.dart';

import 'package:clean_flutter_app/data/cache/model/task_cm.dart';

extension CacheToDomain on TaskCM {
  Task toDM() => Task(
        id: id,
        title: title,
      );
}
