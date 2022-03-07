import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Themes{

  static ThemeData ligtTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: IconThemeData(
          color: Colors.black87,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black87,
          size: 24,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        )
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 10.0,
      unselectedItemColor: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontSize:20,
        color: Colors.black,
      ),
      headline1: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headline2:  TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      headline3: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black87,
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black87,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        )
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 10.0,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.black87,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontSize:20,
        color: Colors.white,
      ),
      headline1: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headline2:  TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
      headline3: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
  );
}