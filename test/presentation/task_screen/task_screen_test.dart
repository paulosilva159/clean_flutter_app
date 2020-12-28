// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
//
// import 'package:domain/exceptions.dart';
// import 'package:domain/model/task.dart';
//
// import 'package:clean_flutter_app/global_provider.dart';
// import 'package:clean_flutter_app/hive_initializer.dart';
// import 'package:clean_flutter_app/generated/l10n.dart';
// import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
// import 'package:clean_flutter_app/presentation/task_screen/task_screen.dart';
// import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
// import 'package:clean_flutter_app/presentation/common/upsert_task_dialog_button.dart';
//
// class TaskScreenUseCasesSpy extends Mock implements TaskScreenUseCases {}
//
// void main() {
//   const _mockLocale = Locale('en_US');
//
//   TaskScreenUseCasesSpy useCases;
//   TaskScreenBloc bloc;
//   Widget screen;
//
//   PostExpectation mockRequestCall() => when(useCases.addTask(any));
//
//   void mockSuccess({List<Task> tasks = const <Task>[]}) =>
//       mockRequestCall().thenAnswer((_) async => Future<void>.value());
//
//   // void mockFailure() => mockRequestCall().thenThrow(UseCaseException());
//
//   setUpAll(hiveInitializer);
//
//   setUp(() {
//     useCases = TaskScreenUseCasesSpy();
//
//     bloc = TaskScreenBloc(
//       useCases: useCases,
//     );
//
//     screen = MaterialApp(
//       localizationsDelegates: const [
//         S.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: S.delegate.supportedLocales,
//       locale: _mockLocale,
//       home: GlobalProvider(
//         child: TaskScreen(
//           bloc: bloc,
//         ),
//       ),
//     );
//
//     mockSuccess();
//   });
//
//   testWidgets('Should not present FloatActionButton in case of Loading State',
//       (tester) async {
//     await tester.pumpWidget(screen);
//     await tester.pump();
//
//     expect(find.byType(FloatingActionButton), findsNothing);
//   });
//
//   testWidgets(
//       'Should present FloatActionButton in case of SuccessfullyLoaded State',
//       (tester) async {
//     await tester.pumpWidget(screen);
//     await tester.pump();
//
//     bloc.updateTaskListStatusSubject(Stream.value(TaskListLoaded(listSize: 0)));
//     await tester.pump();
//
//     expect(find.byType(FloatingActionButton), findsOneWidget);
//   });
//
//   testWidgets('Should present AdaptiveFormDialog on AddTaskButton',
//       (tester) async {
//     final button = find.byType(FloatingActionButton);
//
//     await tester.pumpWidget(screen);
//     await tester.pump();
//
//     bloc.updateTaskListStatusSubject(Stream.value(TaskListLoaded(listSize: 0)));
//     await tester.pump();
//
//     expect(button, findsOneWidget);
//
//     await tester.ensureVisible(button);
//     await tester.tap(button);
//     await tester.pump(Duration.zero);
//
//     // Dont know how to test Dialog
//
//     expect(find.byType(UpsertTaskDialogButton), findsOneWidget);
//   }, skip: true);
//
//   testWidgets('Should present SnackBar', (tester) async {
//     // Dont know how to test SnackBar
//   }, skip: true);
// }
