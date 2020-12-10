import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'task_cm.g.dart';

@HiveType(typeId: 0)
class TaskCM {
  const TaskCM({
    @required this.title,
    @required this.id,
  })  : assert(title != null),
        assert(id != null);

  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
}
