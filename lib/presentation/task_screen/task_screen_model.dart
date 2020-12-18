import 'package:meta/meta.dart';

abstract class TaskScreenState {}

class LoadingList implements TaskScreenState {}

class Error implements TaskScreenState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}

class SuccessfullyLoadedList implements TaskScreenState {}

abstract class TaskScreenAction {}

class UpsertTaskAction implements TaskScreenAction {}
