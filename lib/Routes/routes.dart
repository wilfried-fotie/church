import 'package:church/Views/Home.dart';
import 'package:church/Views/Widgets/MyApp.dart';
import 'package:church/Views/auth/Registration.dart';
import 'package:church/Views/auth/SignIn.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/signIn": (context) => const SignIn(),
  "/register": (context) => const Registration(),
  "/logged": (context) => const MyApp(),
  "/home": (context) => const Home(),
};
