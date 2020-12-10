import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';

import 'package:domain/exceptions.dart';
import 'package:domain/model/task.dart';

class TaskScreenUseCasesSpy extends Mock implements TaskScreenUseCases {}

void main() {
  TaskScreenUseCasesSpy useCases;
  TaskScreenBloc bloc;

  setUp(() {
    useCases = TaskScreenUseCasesSpy();
    bloc = TaskScreenBloc(useCases: useCases);
  });

  test('Should start with Loading state', () async {
    expect(await bloc.onNewState.first, const TypeMatcher<Loading>());
  });

  group('Should call correct state on get list', () {
    PostExpectation mockRequestCall() => when(useCases.getTasksList());

    void mockSuccess({List<Task> tasks = const <Task>[]}) =>
        mockRequestCall().thenAnswer((_) => Future.value(tasks));

    void mockFailure() => mockRequestCall().thenThrow(UseCaseException());

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
    });

    test('Should emit Listing if use case return a list not empty', () async {
      mockSuccess(tasks: <Task>[Task(id: 0, title: 'title')]);

      await Future.delayed(const Duration(seconds: 0));

      bloc.onNewState.listen(
        expectAsync1(
          (state) {
            expect(state, const TypeMatcher<Success>());
            expect(state, const TypeMatcher<Listing>());
          },
        ),
      );
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
  });
}
