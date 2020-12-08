import 'package:meta/meta.dart';

import 'package:domain/model/task.dart';

abstract class TaskScreenState {}

class Loading implements TaskScreenState {}

class Error implements TaskScreenState {
  Error({
    @required this.error,
  }) : assert(error != null);

  final dynamic error;
}

abstract class Success implements TaskScreenState {}

class Empty implements Success {}

class Listing implements Success {
  Listing({
    @required this.tasks,
  }) : assert(tasks != null);

  final List<Task> tasks;
}
