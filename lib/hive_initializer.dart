import 'package:clean_flutter_app/data/cache/model/task_cm.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> hiveInitializer() async {
  Hive
    ..init((await getApplicationDocumentsDirectory()).path)
    ..registerAdapter<TaskCM>(TaskCMAdapter());
}
