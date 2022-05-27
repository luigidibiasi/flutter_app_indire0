import 'package:flutter/material.dart';


class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData( //2
        primaryColor: Color.fromRGBO(222,165,13, .8),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Open sans', //3
        elevatedButtonTheme: ElevatedButtonThemeData( // 4
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.black,
            primary: Color.fromRGBO(222,165,13, .8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          headline2: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
            headline4: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal, color: Colors.black),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind')
        ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromRGBO(222,165,13, .8),
        titleTextStyle: TextStyle(color: Colors.white,
            fontFamily: 'Open sans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color.fromRGBO(222,165,13, .8),
        secondary:Color.fromRGBO(222,165,13, .8),
      ),
    );
  }
}