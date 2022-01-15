import 'dart:html';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:test/navbar/navbar.dart';
import 'package:test/landing/landing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        primarySwatch: Colors.lightGreen,
        sliderTheme: SliderThemeData.fromPrimaryColors(
          primaryColor: Colors.lightGreen,
          primaryColorDark: const Color.fromRGBO(29, 185, 84, 1.0),
          primaryColorLight: Colors.lightGreenAccent,
          valueIndicatorTextStyle: const TextStyle(color: Colors.white),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sortify-background-2.PNG'),
            fit: BoxFit.cover,
            //alignment: Alignment.,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.topCenter,
            color: const Color.fromRGBO(15, 10, 10, 0.90),
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 5,
                  child: navbar(),
                ),
                const Spacer(flex: 1),
                Flexible(flex: 25, child: landing()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(25, 20, 20, 1.0),Color.fromRGBO(29, 185, 84, 1.0)]
          ),
*/