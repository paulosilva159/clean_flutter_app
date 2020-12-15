import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';

import 'package:domain/data_observables.dart';
import 'package:domain/exceptions.dart';
import 'package:domain/model/task.dart';

class TaskScreenUseCasesSpy extends Mock implements TaskScreenUseCases {}

void main() {
  final _activeTaskStorageSubject = PublishSubject<void>();

  void dispose() {
    _activeTaskStorageSubject.close();
  }

  ActiveTaskStorageUpdateStreamWrapper activeTaskStorageUpdateStreamWrapper;
  TaskScreenUseCasesSpy useCases;
  TaskScreenBloc bloc;

  setUp(() {
    activeTaskStorageUpdateStreamWrapper = ActiveTaskStorageUpdateStreamWrapper(
      _activeTaskStorageSubject.stream,
    );
    useCases = TaskScreenUseCasesSpy();
    bloc = TaskScreenBloc(
      useCases: useCases,
      activeTaskStorageUpdateStreamWrapper:
          activeTaskStorageUpdateStreamWrapper,
    );
  });

  test('Should start with Loading state', () async {
    expect(await bloc.onNewState.first, const TypeMatcher<Loading>());

    dispose();
  });

  group('Should call correct state on get task list', () {
    PostExpectation mockRequestGetCall() => when(useCases.getTasksList());

    void mockSuccess({List<Task> tasks = const <Task>[]}) =>
        mockRequestGetCall().thenAnswer((_) => Future.value(tasks));

    void mockFailure() => mockRequestGetCall().thenThrow(UseCaseException());

    test('Should emit Empty if use case return null or an empty list',
        () async {
      mockSuccess();

      await Future.delayed(const Duration(seconds: 0));

      bloc.onNewState.listen(
        expectAsync1(
          (state) {
            expect(state, const TypeMatcher<Success>());
            expect(state, const TypeMatcher<Empty>());
          },
        ),
      );

      dispose();
    });

    test('Should emit Listing if use case return a list not empty', () async {
      mockSuccess(tasks: const <Task>[Task(id: 0, title: 'title')]);

      await Future.delayed(const Duration(seconds: 0));

      bloc.onNewState.listen(
        expectAsync1(
          (state) {
            expect(state, const TypeMatcher<Success>());
            expect(state, const TypeMatcher<Listing>());
          },
        ),
      );

      dispose();
    });

    test('Should emit Error if use case throws', () async {
      mockFailure();

      await Future.delayed(const Duration(seconds: 0));

      bloc.onNewState.listen(
        expectAsync1(
          (state) {
            expect(state, const TypeMatcher<Error>());
          },
        ),
      );

      dispose();
    });

    test('Should emit Error in case of failed try again', () async {
      mockFailure();

      bloc.onTryAgain.add(null);
      await Future.delayed(const Duration(seconds: 0));

      bloc.onNewState.listen(
        expectAsync1(
          (state) {
            expect(state, const TypeMatcher<Error>());
          },
        ),
      );

      dispose();
    });

    test('Should emit Success in case of successful try again', () async {
      mockSuccess();

      bloc.onTryAgain.add(null);
      await Future.delayed(const Duration(seconds: 0));

      bloc.onNewState.listen(
        expectAsync1(
          (state) {
            expect(state, const TypeMatcher<Success>());
          },
        ),
      );
    });

    dispose();
  });

  group('Should call correct state on upsert task', () {
    Task task;

    PostExpectation mockRequestAddCall() => when(
          useCases.upsertTask(any),
        );

    void mockSuccess() =>
        mockRequestAddCall().thenAnswer((_) => Future<void>.value());

    void mockFailure() => mockRequestAddCall().thenThrow(UseCaseException());

    setUp(() async {
      task = const Task(id: 0, title: 'title');

      bloc.getTaskItemListSubject(Stream.value(null));
      await Future.delayed(const Duration(seconds: 0));
    });

    test('Should correctly upsert a task', () async {
      mockSuccess();

      bloc.onUpsertTaskItem.add(task);

      await Future.delayed(const Duration(seconds: 0));

      bloc.onNewState.listen(
        expectAsync1(
          (state) {
            expect(state, const TypeMatcher<Success>());
          },
        ),
      );

      dispose();
    });

    test('Should present Error state on failed save task', () async {
      mockFailure();

      bloc.onUpsertTaskItem.add(task);
      await Future.delayed(const Duration(seconds: 0));

      bloc.onNewState.listen(
        expectAsync1(
          (state) {
            expect(state, const TypeMatcher<Error>());
          },
        ),
      );
    });

    dispose();
  });

  group('Should call correct state on remove task', () {
    Task task;

    PostExpectation mockRequestAddCall() => when(
          useCases.removeTask(any),
        );

    void mockSuccess() =>
        mockRequestAddCall().thenAnswer((_) => Future<void>.value());

    void mockFailure() => mockRequestAddCall().thenThrow(UseCaseException());

    setUp(() async {
      task = const Task(id: 0, title: 'title');

      bloc.getTaskItemListSubject(Stream.value(null));
      await Future.delayed(const Duration(seconds: 0));
    });

    test('Should correctly remove a task', () async {
      mockSuccess();

      bloc.onRemoveTaskItem.add(task);
      await Future.delayed(const Duration(seconds: 0));

      bloc.onNewState.listen(
        expectAsync1(
          (state) {
            expect(state, const TypeMatcher<Success>());
          },
        ),
      );

      dispose();
    });

    test('Should present Error state on failed remove task', () async {
      mockFailure();

      bloc.onRemoveTaskItem.add(task);
      await Future.delayed(const Duration(seconds: 0));

      bloc.onNewState.listen(
        expectAsync1(
          (state) {
            expect(state, const TypeMatcher<Error>());
          },
        ),
      );
    });

    dispose();
  });
}
