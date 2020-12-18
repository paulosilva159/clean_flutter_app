import 'package:clean_flutter_app/presentation/common/task_list_status.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_model.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class TaskScreenUseCasesSpy extends Mock implements TaskScreenUseCases {}

void main() {
  TaskScreenUseCasesSpy useCases;
  TaskScreenBloc bloc;

  setUp(() {
    useCases = TaskScreenUseCasesSpy();
    bloc = TaskScreenBloc(useCases: useCases);
  });

  test('Should start with LoadingList', () {
    expect(bloc.onNewState, emits(isA<WaitingData>()));
  });

  test('Should emit LoadedList when TaskList successfully loads', () async {
    bloc.onNewTaskListStatus.add(TaskListStatus.loaded);
    await Future.delayed(Duration.zero);

    expect(bloc.onNewState, emits(isA<DataLoaded>()));
  });

  // TODO(paulosilva): #2 implementar testes assim que Action estiver ok
}
