// import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
// import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
// import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';
// import 'package:domain/data_repository/task_repository.dart';
// import 'package:domain/model/task.dart';
// import 'package:mockito/mockito.dart';
// import 'package:test/test.dart';
//
// class TaskScreenUseCasesSpy extends Mock implements TaskScreenUseCases {}
//
// void main() {
//   TaskScreenUseCasesSpy useCases;
//   TaskScreenBloc bloc;
//
//   PostExpectation mockRequestCall() => when(useCases.addTask(any));
//
//   void mockSuccessCall() =>
//       mockRequestCall().thenAnswer((_) => Future<void>.value());
//
//   void mockFailureCall() => mockRequestCall().thenThrow((_) => Exception());
//
//   setUp(() {
//     useCases = TaskScreenUseCasesSpy();
//     bloc = TaskScreenBloc(useCases: useCases);
//
//     mockSuccessCall();
//   });
//
//   test('Should start with LoadingList', () {
//     expect(bloc.onNewState, emits(isA<Waiting>()));
//   });
//
//   test('Should emit LoadedList when TaskList successfully loads', () async {
//     bloc.onNewTaskListStatus.add(TaskListLoaded(listSize: 1));
//     await Future.delayed(Duration.zero);
//
//     expect(bloc.onNewState, emits(isA<Done>()));
//   });
//
//   test('Should emit add task action when function is successfully called',
//       () async {
//     expect(bloc.onNewAction, emits(isA<ShowSuccessTaskAction>()));
//
//     bloc.addTaskItemSubject(
//       Stream.value(
//         const Task(
//           title: 'title',
//           orientation: TaskListOrientation.vertical,
//           id: 0,
//         ),
//       ),
//     );
//     await Future.delayed(Duration.zero);
//   });
//
//   test('Should emit fail action when properly function fails to call',
//       () async {
//     mockFailureCall();
//
//     expect(bloc.onNewAction, emits(isA<ShowFailTaskAction>()));
//
//     bloc.addTaskItemSubject(
//       Stream.value(
//         const Task(
//           title: 'title',
//           orientation: TaskListOrientation.vertical,
//           id: 0,
//         ),
//       ),
//     );
//     await Future.delayed(Duration.zero);
//   });
// }
