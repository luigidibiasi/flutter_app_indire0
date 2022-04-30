import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/screens/screen_gestione/insert_activity.dart';
import 'package:flutter_app2/screens/screen_gestione/modify_user.dart';
import 'package:flutter_app2/screens/screen_home/homepage.dart';
import 'package:flutter_app2/screens/splash_screen.dart';
import 'package:flutter_app2/screens/screen_login/login.dart';
import 'package:flutter_app2/screens/screen_menu/menu_admin.dart';
import 'package:flutter_app2/screens/screen_gestione/manage_users.dart';
import 'package:flutter_app2/screens/screen_gestione/insert_user.dart';
import 'package:flutter_app2/screens/screen_gestione/manage_activities.dart';
import 'package:flutter_app2/screens/screen_gestione/insert_activity.dart';
import 'package:flutter_app2/screens/screen_gestione/modify_activity.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    '/home': (context) => MyHomePage(),
    '/': (context) => SplashScreen(),
    '/login': (context) => Login (),
    '/menu_admin': (context) => MenuAdmin (),
    '/menu_utente': (context) => MenuAdmin (),
    '/manage_users': (context)=> ManageUsers(),
    '/insert_user': (context) => RegisterPage(),
    '/manage_activities': (context) => ManageActivities(),
    '/insert_activity': (context) => InsertActivity(),
    '/modify_activity': (context) => ModifyActivity(),
    '/modify_user': (context) => ModifyUser(),
};