import 'package:church/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'ModelView/BottomNavigationOffstage.dart';
import 'ModelView/MyLogin.dart';
import 'Routes/routes.dart';
import 'Themes.dart';
import 'Views/auth/Choice.dart';
import 'helper/SharedPref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AdaptiveThemeMode? savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp();
  await ProfilPreferences.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor, systemNavigationBarColor: Colors.black));
  FirebaseAuth _auth = FirebaseAuth.instance;
  runApp(AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MultiProvider(
            providers: [
              Provider<AdaptiveThemeMode?>.value(value: savedThemeMode),
              StreamProvider<User?>.value(
                  value: _auth.authStateChanges(), initialData: null),
              ChangeNotifierProvider(
                create: (_) => BottomNavigationOffstage(),
              ),
              ChangeNotifierProvider(
                create: (_) => MyLogin(),
              ),
            ],
            child: MaterialApp(
                title: 'Eglise App',
                routes: routes,
                debugShowCheckedModeBanner: false,
                theme: theme,
                darkTheme: darkTheme,
                home: const Choice()),
          )));
}
