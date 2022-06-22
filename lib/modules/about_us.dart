import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class aboutUs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child:   Image.asset(
                  "assets/images/pro.jpg",
                  //height: 250,
                ),
              ),
            ),
          ],
        ),

             Padding(
               padding: const EdgeInsets.all(15.0),

               child: Column(

                 mainAxisAlignment: MainAxisAlignment.start,

                 children: const <Widget>[

                   Text(
                     'ABOUT THE APP',
                     style: TextStyle(
                         fontWeight: FontWeight.w900,
                         fontSize: 20,
                         color: Colors.black
                     ),
                   ),

                   Text(
                     '__________________________',
                     style: TextStyle(
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w200,
                         color: Colors.black),
                   ),

                   SizedBox(height: 15,),

                   Text(
                     'It\'s unofficial app for test covid-19 status and tracking it'
                         ' world wide.\nIf your result be positive you should go and take PCR test.\nWe are group of senior students who seek for helping sick people who may suffering from covid-19.'
                         ' \nThis app is part of our graduation project.\nIt\'s totally free and anyone can use it.\n'
                         'Our test is simple (you just need to answer short questions and record your cough sound), fast and accuracy up to 97%.\n'
                         'Please note that your data is private, however it\'s required for our training model to improve test accuracy.',
                     style: TextStyle(fontWeight: FontWeight.w500,
                         fontFamily: 'Poppins',
                         fontSize: 15,
                         color: Colors.black),
                   ),

//
                 ],
                ),
             ),


          ],
        ),

      ),
    );
  }

}