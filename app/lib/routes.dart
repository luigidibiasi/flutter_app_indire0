import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/screens/screen_home/homepage.dart';
import 'package:flutter_app2/screens/splash_screen.dart';
import 'package:flutter_app2/screens/screen_login/login.dart';
import 'package:flutter_app2/screens/screen_menu/menu_admin.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    '/home': (context) => MyHomePage(),
    '/': (context) => SplashScreen(),
    '/login': (context) => Login (),
    '/menu_admin': (context) => MenuAdmin (),
};