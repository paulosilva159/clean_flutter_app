import 'package:clean_flutter_app/common/utils.dart';
import 'package:clean_flutter_app/data/cache/source/task_cds.dart';
import 'package:clean_flutter_app/data/repository/task_repository.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';
import 'package:clean_flutter_app/presentation/task_screen/vertical_task_list_view/vertical_task_list_view_bloc.dart';
import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/use_case/add_task_uc.dart';
import 'package:domain/use_case/get_vertical_task_list_uc.dart';
import 'package:domain/use_case/remove_task_uc.dart';
import 'package:domain/use_case/reorder_tasks_uc.dart';
import 'package:domain/use_case/update_task_uc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';

class GlobalProvider extends StatefulWidget {
  const GlobalProvider({@required this.child}) : assert(child != null);

  final Widget child;

  @override
  _GlobalProviderState createState() => _GlobalProviderState();
}

class _GlobalProviderState extends State<GlobalProvider> {
  final _activeTaskStorageSubject = PublishSubject<void>();

  @override
  void dispose() {
    _activeTaskStorageSubject.close();
    super.dispose();
  }

  SingleChildWidget _buildLogProvider() => Provider<Log>(
        create: (context) => Log(),
      );

  List<SingleChildWidget> _buildDataObservablesProvider() => [
        Provider<ActiveTaskStorageUpdateStreamWrapper>(
          create: (context) => ActiveTaskStorageUpdateStreamWrapper(
            _activeTaskStorageSubject.stream,
          ),
        ),
        Provider<ActiveTaskStorageUpdateSinkWrapper>(
          create: (context) => ActiveTaskStorageUpdateSinkWrapper(
            _activeTaskStorageSubject.sink,
          ),
        ),
      ];

  SingleChildWidget _buildCacheDataSourceProvider() => Provider<TaskCDS>(
        create: (context) => TaskCDS(),
      );

  SingleChildWidget _buildRepositoryProvider() =>
      ProxyProvider<TaskCDS, TaskDataRepository>(
        update: (context, taskCDS, _) => TaskRepository(cacheDS: taskCDS),
      );

  List<SingleChildWidget> _buildUseCasesProvider() => [
        ProxyProvider2<Log, TaskDataRepository, GetTaskListUC>(
          update: (context, log, taskRepository, _) => GetTaskListUC(
            logger: log.errorLogger,
            repository: taskRepository,
          ),
        ),
        ProxyProvider3<Log, TaskDataRepository,
            ActiveTaskStorageUpdateSinkWrapper, AddTaskUC>(
          update: (context, log, taskRepository,
                  activeTaskStorageUpdateSinkWrapper, _) =>
              AddTaskUC(
            logger: log.errorLogger,
            repository: taskRepository,
            activeTaskStorageUpdateSinkWrapper:
                activeTaskStorageUpdateSinkWrapper,
          ),
        ),
        ProxyProvider3<Log, TaskDataRepository,
            ActiveTaskStorageUpdateSinkWrapper, UpdateTaskUC>(
          update: (context, log, taskRepository,
                  activeTaskStorageUpdateSinkWrapper, _) =>
              UpdateTaskUC(
            logger: log.errorLogger,
            repository: taskRepository,
            activeTaskStorageUpdateSinkWrapper:
                activeTaskStorageUpdateSinkWrapper,
          ),
        ),
        ProxyProvider3<Log, TaskDataRepository,
            ActiveTaskStorageUpdateSinkWrapper, RemoveTaskUC>(
          update: (context, log, taskRepository,
                  activeTaskStorageUpdateSinkWrapper, _) =>
              RemoveTaskUC(
            logger: log.errorLogger,
            repository: taskRepository,
            activeTaskStorageUpdateSinkWrapper:
                activeTaskStorageUpdateSinkWrapper,
          ),
        ),
        ProxyProvider3<Log, TaskDataRepository,
            ActiveTaskStorageUpdateSinkWrapper, ReorderTasksUC>(
          update: (context, log, taskRepository,
                  activeTaskStorageUpdateSinkWrapper, _) =>
              ReorderTasksUC(
            logger: log.errorLogger,
            repository: taskRepository,
            activeTaskStorageUpdateSinkWrapper:
                activeTaskStorageUpdateSinkWrapper,
          ),
        ),
      ];

  List<SingleChildWidget> _buildScreensUseCasesProvider() => [
        ProxyProvider<AddTaskUC, TaskScreenUseCases>(
          update: (context, addTaskUC, _) => TaskScreenUseCases(
            addTaskUC: addTaskUC,
          ),
        ),
        ProxyProvider4<GetTaskListUC, UpdateTaskUC, RemoveTaskUC,
            ReorderTasksUC, VerticalTaskListViewUseCases>(
          update: (context, getTaskListUC, updateTaskUC, removeTaskUC,
                  reorderTasksUC, _) =>
              VerticalTaskListViewUseCases(
            getTaskListUC: getTaskListUC,
            removeTaskUC: removeTaskUC,
            updateTaskUC: updateTaskUC,
            reorderTasksUC: reorderTasksUC,
          ),
        )
      ];

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          _buildLogProvider(),
          ..._buildDataObservablesProvider(),
          _buildCacheDataSourceProvider(),
          _buildRepositoryProvider(),
          ..._buildUseCasesProvider(),
          ..._buildScreensUseCasesProvider()
        ],
        child: widget.child,
      );
}
