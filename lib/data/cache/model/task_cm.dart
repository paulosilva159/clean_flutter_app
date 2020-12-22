import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'task_cm.g.dart';

@HiveType(typeId: 0)
class TaskCM {
  const TaskCM({
    @required this.id,
    @required this.title,
    @required this.orientation,
  })  : assert(id != null),
        assert(title != null),
        assert(orientation != null);

  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String orientation;
}
