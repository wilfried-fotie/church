import 'package:flutter/material.dart';
import 'tools.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Noto",
    primaryColorLight: kBackColor,
    hoverColor: Colors.white,
    primaryColor: kTextColor,
    cardTheme: const CardTheme(
      shadowColor: kBackColor,
    ),
    textTheme: const TextTheme(headline6: kBold),
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: kBoldTextPrimaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: kPrimaryColor)),
    splashColor: kPrimaryColor);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Noto",
    primaryColor: Colors.white,
    hoverColor: kTextColor,
    textTheme: const TextTheme(headline6: kBoldWhite),
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        titleTextStyle: kBoldTextPrimaryColor,
        iconTheme: IconThemeData(color: kPrimaryColor)),
    splashColor: kSecondaryColor);
