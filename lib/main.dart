import 'package:flutter/material.dart';

import 'package:clean_flutter_app/presentation/task_screen/task_screen.dart';

void main() {
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
