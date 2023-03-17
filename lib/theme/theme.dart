import 'package:emarketapp/constants/values/colors.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData customTheme = ThemeData.light().copyWith(
    primaryColor: Colors.black,
    /*textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
          fontFamily: 'Hezaedrus',
        ),*/
    textTheme: const TextTheme(
      headline1: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 96),
      headline2: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 60),
      headline3: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 48),
      headline4: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 34),
      headline5: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 24),
      headline6: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 20),
      subtitle1: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 16),
      subtitle2: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 14),
      bodyText1: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 16),
      bodyText2: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 14),
      button: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 12),
      caption: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 10),
      overline: TextStyle(color: Colors.black, fontFamily: 'Hezaedrus', fontSize: 7),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: UiColorHelper.mainYellow,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    //textSelectionTheme: const TextSelectionThemeData(cursorColor: UiColorHelper.grayColor),
    /*textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: UiColorHelper.grayColor, // button text color
      ),
    ),*/
  );
}
