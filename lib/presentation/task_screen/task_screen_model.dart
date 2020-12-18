abstract class TaskScreenState {}

class WaitingData implements TaskScreenState {}

class DataLoaded implements TaskScreenState {}

abstract class TaskScreenAction {}

class UpsertTaskAction implements TaskScreenAction {}
