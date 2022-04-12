import 'package:flutter/material.dart';


class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData( //2
        primaryColor: Colors.lightBlueAccent,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Open sans', //3
        elevatedButtonTheme: ElevatedButtonThemeData( // 4
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.black,
            primary: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 32.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind')
        ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.lightBlueAccent,
      )
    );
  }
}