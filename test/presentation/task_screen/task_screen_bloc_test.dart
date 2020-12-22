import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/model/task.dart';

import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';

class TaskScreenUseCasesSpy extends Mock implements TaskScreenUseCases {}

void main() {
  TaskScreenUseCasesSpy useCases;
  TaskScreenBloc bloc;

  PostExpectation mockRequestCall() => when(useCases.addTask(any));

  void mockSuccessCall() =>
      mockRequestCall().thenAnswer((_) => Future<void>.value());

  void mockFailureCall() => mockRequestCall().thenThrow((_) => Exception());

  setUp(() {
    useCases = TaskScreenUseCasesSpy();
    bloc = TaskScreenBloc(useCases: useCases);

    mockSuccessCall();
  });

  test('Should start with LoadingList', () {
    expect(bloc.onNewState, emits(isA<WaitingData>()));
  });

  test('Should emit LoadedList when TaskList successfully loads', () async {
    bloc.onNewTaskListStatus.add(TaskListStatus.loaded);
    await Future.delayed(Duration.zero);

    expect(bloc.onNewState, emits(isA<DataLoaded>()));
  });

  test('Should emit add task action when function is successfully called',
      () async {
    expect(bloc.onNewAction, emits(isA<AddTaskAction>()));

    bloc.addTaskItemSubject(
      Stream.value(
        const Task(
          title: 'title',
          orientation: TaskListOrientation.vertical,
          id: 0,
        ),
      ),
    );
    await Future.delayed(Duration.zero);
  });

  test('Should emit fail action when properly function fails to call',
      () async {
    mockFailureCall();

    expect(bloc.onNewAction, emits(isA<FailAction>()));

    bloc.addTaskItemSubject(
      Stream.value(
        const Task(
          title: 'title',
          orientation: TaskListOrientation.vertical,
          id: 0,
        ),
      ),
    );
    await Future.delayed(Duration.zero);
  });
}
