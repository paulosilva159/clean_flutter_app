import 'package:clean_flutter_app/presentation/task_screen/task_list_view/task_list_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';

import 'package:clean_flutter_app/common/utils.dart';
import 'package:clean_flutter_app/data/cache/source/task_cds.dart';
import 'package:clean_flutter_app/data/repository/task_repository.dart';
import 'package:clean_flutter_app/presentation/task_screen/task_screen_bloc.dart';

import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/use_case/upsert_task_uc.dart';
import 'package:domain/use_case/get_task_list_uc.dart';
import 'package:domain/use_case/remove_task_uc.dart';

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
            ActiveTaskStorageUpdateSinkWrapper, UpsertTaskUC>(
          update: (context, log, taskRepository,
                  activeTaskStorageUpdateSinkWrapper, _) =>
              UpsertTaskUC(
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
      ];

  List<SingleChildWidget> _buildScreensUseCasesProvider() => [
        ProxyProvider<UpsertTaskUC, TaskScreenUseCases>(
          update: (context, upsertTaskUC, _) => TaskScreenUseCases(
            upsertTaskUC: upsertTaskUC,
          ),
        ),
        ProxyProvider3<GetTaskListUC, UpsertTaskUC, RemoveTaskUC,
            TaskListViewUseCases>(
          update: (context, getTaskListUC, upsertTaskUC, removeTaskUC, _) =>
              TaskListViewUseCases(
            getTaskListUC: getTaskListUC,
            removeTaskUC: removeTaskUC,
            upsertTaskUC: upsertTaskUC,
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
