import 'dart:async';

import 'package:clean_flutter_app/data/cache/model/task_cm.dart';
import 'package:hive/hive.dart';

class TaskCDS {
  static const String _verticalTaskBoxName = '_verticalTaskBox';
  static const String _horizontalTaskBoxName = '_horizontalTaskBox';

  Future<List<TaskCM>> _getTaskList(Future<Box<TaskCM>> onOpenBox) =>
      onOpenBox.then<List<TaskCM>>(
        (box) => box.values.toList(),
      );

  Future<void> _upsertTask(TaskCM task, Future<Box<TaskCM>> onOpenBox) =>
      onOpenBox.then<void>(
        (box) {
          box.values.contains(task)
              ? box.putAt(task.id, task)
              : box.put(task.id, task);
        },
      );

  Future<void> _reorderTask(
          int oldId, int newId, Future<Box<TaskCM>> onOpenBox) =>
      onOpenBox.then<void>(
        (box) async {
          List<TaskCM> _reorderingTask;

          if (oldId < newId) {
            _reorderingTask = box.values
                .where((boxTask) => boxTask.id > oldId && boxTask.id <= newId)
                .toList();
          } else {
            _reorderingTask = box.values
                .where((boxTask) => boxTask.id < oldId && boxTask.id >= newId)
                .toList();
          }

          final _movingTask =
              box.values.where((boxTask) => boxTask.id == oldId).toList().first;

          await box
              .put(
            newId,
            TaskCM(
              id: newId,
              title: _movingTask.title,
              orientation: _movingTask.orientation,
            ),
          )
              .then(
            (_) {
              _reorderingTask.forEach(
                (boxTask) {
                  int _newIndex;

                  if (oldId < newId) {
                    _newIndex = boxTask.id - 1;
                  } else {
                    _newIndex = boxTask.id + 1;
                  }

                  box.put(
                    _newIndex,
                    TaskCM(
                      id: _newIndex,
                      title: boxTask.title,
                      orientation: boxTask.orientation,
                    ),
                  );
                },
              );
            },
          );
        },
      );

  Future<void> _removeTask(TaskCM task, Future<Box<TaskCM>> onOpenBox) =>
      onOpenBox.then<void>(
        (box) {
          final _laterIndexItems =
              box.values.where((boxTask) => boxTask.id > task.id);
          final _isLastIndex = _laterIndexItems?.isEmpty == true;

          if (_isLastIndex) {
            box.delete(task.id);
          } else {
            _laterIndexItems.forEach(
              (boxTask) {
                final _newIndex = boxTask.id - 1;

                box.put(
                  _newIndex,
                  TaskCM(
                    id: _newIndex,
                    title: boxTask.title,
                    orientation: boxTask.orientation,
                  ),
                );
              },
            );

            box.delete(_laterIndexItems.last.id);
          }
        },
      );

  Future<List<TaskCM>> getVerticalTaskList() => _getTaskList(
        Hive.openBox<TaskCM>(_verticalTaskBoxName),
      );
  Future<void> upsertVerticalTask(TaskCM task) => _upsertTask(
        task,
        Hive.openBox<TaskCM>(_verticalTaskBoxName),
      );
  Future<void> reorderVerticalTask(int oldId, int newId) => _reorderTask(
        oldId,
        newId,
        Hive.openBox<TaskCM>(_verticalTaskBoxName),
      );
  Future<void> removeVerticalTask(TaskCM task) => _removeTask(
        task,
        Hive.openBox<TaskCM>(_verticalTaskBoxName),
      );

  Future<List<TaskCM>> getHorizontalTaskList() => _getTaskList(
        Hive.openBox<TaskCM>(_horizontalTaskBoxName),
      );
  Future<void> upsertHorizontalTask(TaskCM task) => _upsertTask(
        task,
        Hive.openBox<TaskCM>(_horizontalTaskBoxName),
      );
  Future<void> reorderHorizontalTask(int oldId, int newId) => _reorderTask(
        oldId,
        newId,
        Hive.openBox<TaskCM>(_horizontalTaskBoxName),
      );
  Future<void> removeHorizontalTask(TaskCM task) => _removeTask(
        task,
        Hive.openBox<TaskCM>(_horizontalTaskBoxName),
      );
}
