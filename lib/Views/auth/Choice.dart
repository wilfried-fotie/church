import 'package:church/ModelView/MyLogin.dart';
import 'package:church/Views/Home.dart';
import 'package:church/Views/Widgets/MyApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Choice extends StatelessWidget {
  const Choice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<User?>(builder: (context, ctx, child) {
      return ctx?.uid != null ? const MyApp() : const Home();
    }));
  }
}
