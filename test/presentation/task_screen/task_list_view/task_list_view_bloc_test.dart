import 'dart:async';

import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/vertical_task_list_view_model.dart';
import 'package:domain/data_repository/task_repository.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/vertical_task_list_view_bloc.dart';

import 'package:domain/data_observables.dart';
import 'package:domain/exceptions.dart';
import 'package:domain/model/task.dart';

class ActiveTaskStorageUpdateStreamWrapperSpy extends Mock
    implements ActiveTaskStorageUpdateStreamWrapper {}

class TaskListViewUseCasesSpy extends Mock
    implements VerticalTaskListViewUseCases {}

void main() {
  const task =
      Task(id: 0, title: 'title', orientation: TaskListOrientation.vertical);

  ActiveTaskStorageUpdateStreamWrapperSpy activeTaskStorageUpdateStreamWrapper;
  TaskListViewUseCasesSpy useCases;
  VerticalTaskListViewBloc bloc;

  PostExpectation mockRequestGetCall() => when(useCases.getTasksList());

  void mockGetSuccess({List<Task> tasks = const <Task>[]}) =>
      mockRequestGetCall().thenAnswer((_) => Future.value(tasks));

  void mockGetFailure() => mockRequestGetCall().thenThrow(UseCaseException());

  void mockStreamWrapper() => when(activeTaskStorageUpdateStreamWrapper.value)
      .thenAnswer((_) => Stream.value(null));

  setUp(() {
    activeTaskStorageUpdateStreamWrapper =
        ActiveTaskStorageUpdateStreamWrapperSpy();

    useCases = TaskListViewUseCasesSpy();

    mockStreamWrapper();

    bloc = VerticalTaskListViewBloc(
      useCases: useCases,
      activeTaskStorageUpdateStreamWrapper:
          activeTaskStorageUpdateStreamWrapper,
    );
  });

  test('Should start with Loading state', () {
    expect(bloc.onNewState, emits(isA<Loading>()));
  });

  group('Should call correct state on get task list', () {
    test('Should emit Empty if use case return null or an empty list',
        () async {
      mockGetSuccess();

      bloc.getTaskItemListSubject(Stream.value(null));
      await Future.delayed(const Duration(seconds: 0));

      expect(bloc.onNewState, emits(isA<Empty>()));
    });

    test('Should emit Listing if use case return a list not empty', () async {
      mockGetSuccess(tasks: [task]);

      bloc.getTaskItemListSubject(Stream.value(null));
      await Future.delayed(const Duration(seconds: 0));

      expect(bloc.onNewState, emits(isA<Listing>()));
    });

    test('Should emit Error if use case throws', () async {
      mockGetFailure();

      bloc.getTaskItemListSubject(Stream.value(null));
      await Future.delayed(const Duration(seconds: 0));

      expect(bloc.onNewState, emits(isA<Error>()));
    });

    test('Should emit Error in case of failed try again', () async {
      mockGetFailure();

      bloc.onTryAgain.add(null);
      await Future.delayed(const Duration(seconds: 0));

      expect(bloc.onNewState, emits(isA<Error>()));
    });

    test('Should emit Success in case of successful try again', () async {
      mockGetFailure();

      bloc.onTryAgain.add(null);
      await Future.delayed(const Duration(seconds: 0));

      expect(bloc.onNewState, emits(isA<Error>()));

      mockGetSuccess();

      bloc.onTryAgain.add(null);
      await Future.delayed(const Duration(seconds: 0));

      expect(bloc.onNewState, emits(isA<Success>()));
    });
  });

  group('Should call correct state on upsert task', () {
    PostExpectation mockRequestAddCall() => when(
          useCases.updateTask(any),
        );

    void mockSuccess() => mockRequestAddCall().thenAnswer((_) {
          mockGetSuccess(tasks: [task]);
          bloc.getTaskItemListSubject(Stream.value(null));
        });

    void mockFailure() => mockRequestAddCall().thenThrow(UseCaseException());

    setUp(() async {
      await Future.delayed(const Duration(seconds: 0));
    });

    test('Should correctly upsert a task', () async {
      mockSuccess();

      expect(bloc.onNewState, emits(isA<Empty>()));

      bloc.onUpdateTaskItem.add(task);
      await Future.delayed(const Duration(seconds: 0));

      expect(bloc.onNewState, emits(isA<Listing>()));
    });

    test('Should present Error state on failed save task', () async {
      mockFailure();

      expect(bloc.onNewState, emits(isA<Empty>()));

      bloc.onUpdateTaskItem.add(task);
      await Future.delayed(const Duration(seconds: 0));

      expect(bloc.onNewState, emits(isA<Error>()));
    });
  });

  group('Should call correct state on remove task', () {
    PostExpectation mockRequestRemoveCall() => when(
          useCases.removeTask(any),
        );

    void mockRemoveSuccess() => mockRequestRemoveCall()
        .thenAnswer((_) => bloc.getTaskItemListSubject(Stream.value(null)));

    void mockRemoveFailure() =>
        mockRequestRemoveCall().thenThrow(UseCaseException());

    setUp(() async {
      mockGetSuccess(tasks: [task]);

      bloc.getTaskItemListSubject(Stream.value(null));
      await Future.delayed(const Duration(seconds: 0));
    });

    test('Should correctly remove a task', () async {
      mockRemoveSuccess();

      expect(bloc.onNewState, emits(isA<Listing>()));

      bloc.onRemoveTaskItem.add(task);
      await Future.delayed(const Duration(seconds: 0));

      expect(bloc.onNewState, emits(isA<Success>()));
    });

    test('Should present Error state on failed remove task', () async {
      mockRemoveFailure();

      expect(bloc.onNewState, emits(isA<Listing>()));

      bloc.onRemoveTaskItem.add(task);
      await Future.delayed(const Duration(seconds: 0));

      expect(bloc.onNewState, emits(isA<Error>()));
    });
  });
}
