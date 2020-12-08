import 'package:clean_flutter_app/common/try_again_button.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_uc.dart';
import 'package:clean_flutter_app/presentation/task_screen/widget/task_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:domain/exceptions.dart';
import 'package:domain/model/task.dart';

import 'package:clean_flutter_app/common/indicator/empty_list_indicator.dart';
import 'package:clean_flutter_app/common/indicator/loading_indicator.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';

class TaskScreenUseCasesSpy extends Mock implements TaskScreenUseCases {}

void main() {
  TaskScreenUseCasesSpy useCases;
  TaskScreenBloc bloc;
  Widget screen;

  PostExpectation mockRequestCall() => when(useCases.getTasksList());

  void mockSuccess({List<Task> tasks = const <Task>[]}) =>
      mockRequestCall().thenAnswer((_) async => tasks);

  void mockFailure() => mockRequestCall().thenThrow(UseCaseException());

  setUp(() {
    useCases = TaskScreenUseCasesSpy();
    bloc = TaskScreenBloc(useCases: useCases);

    screen = MaterialApp(
      home: TaskScreen(
        bloc: bloc,
      ),
    );

    mockSuccess();
  });

  testWidgets('Should start with Loading Indicator', (tester) async {
    await tester.pumpWidget(screen);

    expect(find.byType(LoadingIndicator), findsOneWidget);
  });

  testWidgets('Should emit EmptyList Indicator if found list is empty',
      (tester) async {
    await tester.pumpWidget(screen);

    bloc.updateNewStateSubject(Stream.value(null));
    await tester.pump();

    expect(find.byType(EmptyListIndicator), findsOneWidget);
  });

  testWidgets('Should emit ListView if found list is not empty',
      (tester) async {
    mockSuccess(tasks: <Task>[Task(title: 'title')]);

    await tester.pumpWidget(screen);

    bloc.updateNewStateSubject(Stream.value(null));
    await tester.pump();

    expect(find.byType(TaskListView), findsOneWidget);
  });

  testWidgets('Should present TryAgainButton in case of Error', (tester) async {
    mockFailure();

    await tester.pumpWidget(screen);

    bloc.updateNewStateSubject(Stream.value(null));
    await tester.pump();

    expect(find.byType(TryAgainButton), findsOneWidget);
  });

  testWidgets('Should not present FloatActionButton in case of Loading State',
      (tester) async {
    await tester.pumpWidget(screen);

    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('Should not present FloatActionButton in case of Error State',
      (tester) async {
    mockFailure();

    await tester.pumpWidget(screen);

    bloc.updateNewStateSubject(Stream.value(null));
    await tester.pump();

    expect(find.byType(FloatingActionButton), findsNothing);
  });
}
