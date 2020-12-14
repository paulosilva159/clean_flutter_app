import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:clean_flutter_app/global_provider.dart';
import 'package:domain/data_observables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

import 'package:domain/exceptions.dart';
import 'package:domain/model/task.dart';

import 'package:clean_flutter_app/presentation/task_screen/task_screen.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/common/indicator/empty_list_indicator.dart';
import 'package:clean_flutter_app/presentation/common/indicator/loading_indicator.dart';
import 'package:clean_flutter_app/presentation/common/try_again_button.dart';
import 'package:clean_flutter_app/presentation/task_screen/widget/task_list_view.dart';
import 'package:rxdart/rxdart.dart';

class TaskScreenUseCasesSpy extends Mock implements TaskScreenUseCases {}

void main() {
  final _activeTaskStorageSubject = PublishSubject<void>();
  const _mockLocale = Locale('en_US');

  void dispose() {
    _activeTaskStorageSubject.close();
  }

  ActiveTaskStorageUpdateStreamWrapper activeTaskStorageUpdateStreamWrapper;
  TaskScreenUseCasesSpy useCases;
  TaskScreenBloc bloc;
  Widget screen;

  PostExpectation mockRequestCall() => when(useCases.getTasksList());

  void mockSuccess({List<Task> tasks = const <Task>[]}) =>
      mockRequestCall().thenAnswer((_) async => tasks);

  void mockFailure() => mockRequestCall().thenThrow(UseCaseException());

  setUp(() {
    activeTaskStorageUpdateStreamWrapper =
        ActiveTaskStorageUpdateStreamWrapper(_activeTaskStorageSubject.stream);
    useCases = TaskScreenUseCasesSpy();
    bloc = TaskScreenBloc(
      useCases: useCases,
      activeTaskStorageUpdateStreamWrapper:
          activeTaskStorageUpdateStreamWrapper,
    );

    screen = MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: _mockLocale,
      home: TaskScreen(
        bloc: bloc,
      ),
    );

    mockSuccess();
  });

  testWidgets('Should start with Loading Indicator', (tester) async {
    await tester.pumpWidget(screen);
    await tester.pump();

    expect(find.byType(LoadingIndicator), findsOneWidget);

    dispose();
  });

  testWidgets('Should emit EmptyList Indicator if found list is empty',
      (tester) async {
    await tester.pumpWidget(screen);
    await tester.pump();

    bloc.getTaskItemListSubject(Stream.value(null));
    await tester.pump();

    expect(find.byType(EmptyListIndicator), findsOneWidget);

    dispose();
  });

  testWidgets('Should emit ListView if found list is not empty',
      (tester) async {
    mockSuccess(tasks: <Task>[Task(id: 0, title: 'title')]);

    await tester.pumpWidget(screen);
    await tester.pump();

    bloc.getTaskItemListSubject(Stream.value(null));
    await tester.pump();

    expect(find.byType(TaskListView), findsOneWidget);

    dispose();
  });

  testWidgets('Should present TryAgainButton in case of Error', (tester) async {
    mockFailure();

    await tester.pumpWidget(screen);
    await tester.pump();

    bloc.getTaskItemListSubject(Stream.value(null));
    await tester.pump();

    expect(find.byType(TryAgainButton), findsOneWidget);

    dispose();
  });

  testWidgets('Should not present FloatActionButton in case of Loading State',
      (tester) async {
    await tester.pumpWidget(screen);
    await tester.pump();

    expect(find.byType(FloatingActionButton), findsNothing);

    dispose();
  });

  testWidgets('Should not present FloatActionButton in case of Error State',
      (tester) async {
    mockFailure();

    await tester.pumpWidget(screen);
    await tester.pump();

    bloc.getTaskItemListSubject(Stream.value(null));
    await tester.pump();

    expect(find.byType(FloatingActionButton), findsNothing);

    dispose();
  });
}
