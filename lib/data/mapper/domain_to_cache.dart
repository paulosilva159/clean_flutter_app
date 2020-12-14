import 'package:clean_flutter_app/data/cache/model/task_cm.dart';
import 'package:domain/model/task.dart';

extension CacheToDomain on Task {
  TaskCM toCM() => TaskCM(
        id: id,
        title: title,
      );
}
