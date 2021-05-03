import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_band/AuthenticationService.dart';
import 'package:music_band/PageTransitionRoute.dart';
import 'package:music_band/loginpage.dart';
import 'package:music_band/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges, initialData: null,),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primaryColor: Colors.amberAccent,
            accentColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.black, displayColor: Colors.black),
          ),
          home: AuthenticationWrapper()
        ));
  }
}
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    Timer(
        Duration(seconds: 3),
            () =>
            Navigator.pushAndRemoveUntil(
                context,
                PageTransitionRoute(
                    widget: firebaseUser != null?HomeScreen():LoginPage()),(Route<dynamic> route) => false));
    return Scaffold(
      body: Container(
        color: Colors.amberAccent,
        child: Center(child: Image.asset('assets/band.png',width: 200,height: 200,)),
      ),
    );
  }
}
