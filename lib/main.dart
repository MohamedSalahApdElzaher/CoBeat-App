// @dart=2.9

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'modules/main_page.dart';


void main() {
  // transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // prevent orintation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Covid-19',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins'
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: SingleChildScrollView(
              child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child:   Image.asset(
                      'assets/images/logo.jpg',
                    ),
                  ),
                SizedBox(
                  height: 15,
                ),

                  Text(
                    "CoBeat",
                    style: TextStyle(color: Color(0xff0563c4), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),

              Text(
                "Take Portable PCR and Fight Covid 19",
                style: TextStyle(color: Color(0xff0563c4), fontWeight: FontWeight.normal),
              ),
                  SizedBox(
                    height: 15,
                  ),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0563c4)),
                )
                ],
              ),
            ),
          ),
        ),
      );

  }
}

