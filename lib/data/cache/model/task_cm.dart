import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'task_cm.g.dart';

// @HiveType(typeId: 0)
// class TaskCM {
//   const TaskCM({
//     @required this.id,
//     @required this.title,
//     @required this.orientation,
//   })  : assert(id != null),
//         assert(title != null),
//         assert(orientation != null);
//
//   @HiveField(0)
//   final int id;
//   @HiveField(1)
//   final String title;
//   @HiveField(2)
//   final String orientation;
// }

@HiveType(typeId: 0)
class TaskCM {
  TaskCM({
    @required this.id,
    @required this.title,
    @required this.status,
    @required this.orientation,
    this.days,
    this.steps,
    this.periodicity,
    this.progress,
  })  : assert(id != null),
        assert(title != null),
        assert(status != null),
        assert(orientation != null);

  @HiveField(0)
  final int id;
  @HiveField(1)
  final int days;
  @HiveField(2)
  final List<Map<String, dynamic>> steps;
  @HiveField(3)
  final int periodicity;
  @HiveField(4)
  final int progress;
  @HiveField(5)
  final String title;
  @HiveField(6)
  final String status;
  @HiveField(7)
  final String orientation;
}
