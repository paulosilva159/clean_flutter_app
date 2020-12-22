import 'package:meta/meta.dart';

abstract class TaskListStatus {}

class TaskListLoading implements TaskListStatus {}

class TaskListLoaded implements TaskListStatus {
  TaskListLoaded({
    @required this.listSize,
  }) : assert(listSize != null);

  final int listSize;
}
