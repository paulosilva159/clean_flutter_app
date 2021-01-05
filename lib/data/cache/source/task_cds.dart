import 'package:clean_flutter_app/data/cache/model/task_cm.dart';
import 'package:domain/common/task_list_orientation.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hive/hive.dart';

class TaskCDS {
  static const String _verticalTaskBoxName = '_verticalTaskBox';
  static const String _horizontalTaskBoxName = '_horizontalTaskBox';

  Future<List<TaskCM>> getTaskList(TaskListOrientation orientation) =>
      Hive.openBox<TaskCM>(
        _chooseBox(
          EnumToString.convertToString(orientation),
        ),
      ).then<List<TaskCM>>(
        (box) => box.values.toList(),
      );

  Future<void> upsertTask(TaskCM task) => Hive.openBox<TaskCM>(
        _chooseBox(task.orientation),
      ).then<void>(
        (box) => box.put(task.id, task),
      );

  Future<void> removeTask(TaskCM task) => Hive.openBox<TaskCM>(
        _chooseBox(task.orientation),
      ).then<void>(
        (box) => box.delete(task.id),
      );

  String _chooseBox(String orientation) {
    final _orientation = EnumToString.fromString<TaskListOrientation>(
      TaskListOrientation.values,
      orientation,
    );

    return _orientation == TaskListOrientation.vertical
        ? _verticalTaskBoxName
        : _horizontalTaskBoxName;
  }
}
