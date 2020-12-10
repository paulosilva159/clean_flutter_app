import 'package:clean_flutter_app/hive_initializer.dart';
import 'package:flutter/material.dart';

import 'package:clean_flutter_app/presentation/task_screen/task_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await hiveInitializer();

  runApp(
    App(),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: SafeArea(
          child: TaskScreen(),
        ),
      );
}
