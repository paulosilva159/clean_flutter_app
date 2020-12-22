import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:clean_flutter_app/global_provider.dart';
import 'package:clean_flutter_app/hive_initializer.dart';
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
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: SafeArea(
          child: GlobalProvider(
            child: TaskScreen.create(),
          ),
        ),
      );
}
