import 'package:domain/common/task_list_orientation.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'task_cm.g.dart';

final _taskListHorizontalOrientation =
    EnumToString.convertToString(TaskListOrientation.horizontal);
final _taskListVerticalOrientation =
    EnumToString.convertToString(TaskListOrientation.vertical);

@HiveType(typeId: 0)
class TaskCM {
  TaskCM({
    @required this.id,
    @required this.title,
    @required this.status,
    @required this.orientation,
    @required this.priority,
    @required this.creationTime,
    this.deadline,
    this.steps,
    this.periodicity,
  })  : assert(id != null),
        assert(title != null),
        assert(status != null),
        assert(priority != null),
        assert(creationTime != null),
        assert(orientation != null),
        assert(
          (orientation == _taskListHorizontalOrientation && steps != null) ||
              (orientation == _taskListVerticalOrientation && deadline != null),
        );

  @HiveField(0)
  final String id;
  @HiveField(1)
  final int periodicity;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String status;
  @HiveField(4)
  final String priority;
  @HiveField(5)
  final String orientation;
  @HiveField(6)
  final DateTime deadline;
  @HiveField(7)
  final DateTime creationTime;
  @HiveField(8)
  final List<Map<String, dynamic>> steps;
}
