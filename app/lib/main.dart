import 'package:flutter/material.dart';
import 'package:flutter_app2/routes.dart';
import 'package:flutter_app2/theme/custom_theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        theme: CustomTheme.lightTheme,
      initialRoute: '/',
      routes: routes
    );
  }
}

