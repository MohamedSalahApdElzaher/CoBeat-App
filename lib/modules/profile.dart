import 'dart:convert';
import 'package:covid/modules/LoginScreen.dart';
import 'package:covid/modules/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {

  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  dynamic group_1 = 1;

   var signed = false;

  check() async {
    var pref = await SharedPreferences.getInstance();
    signed = (pref.getString('token').toString().isEmpty) ? false : true;
    if(signed){
      emailController.text = pref.getString('email').toString();
      phoneController.text = pref.getString('number').toString();
      userNameController.text = pref.getString('name').toString();
    }
    setState(() {});
  }

  /// display not signed in
  goLogin() {
    Fluttertoast.showToast(
      backgroundColor: Colors.red,
      msg: 'Please Login ...',
    );
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    check();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    return !signed ?

    Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child:
                  Text('You don\'t have an account!',
                    style: TextStyle(fontWeight: FontWeight.w900),),
            ),
        ),
    )

        :

     Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
                        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: const Text(
                    'PROFILE',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0563c4),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20.0,
                ),
                //userName
                TextFormField(
                 // initialValue: userNameController.text,
                  controller: userNameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                    labelStyle: TextStyle(color: Color(0xff0563c4)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff0563c4),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xff0563c4),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                //email
                TextFormField(
                  //initialValue: emailController.text,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: Color(0xff0563c4)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff0563c4),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xff0563c4),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20.0,
                ),

                //phone
                TextFormField(
                  //initialValue: phoneController.text,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Color(0xff0563c4)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff0563c4),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xff0563c4),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20.0,
                ),

                const SizedBox(
                  height: 5.0,
                ),
                //register button
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xff0563c4),
                    ),
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        update();
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ))))));

  }

  // update profile

  Future<void> update() async {
    showDialog(
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        context: context);

    var pref = await SharedPreferences.getInstance();
    var id = pref.get('userId');

    var res =
        await http.patch(Uri.parse('https://cough-api.herokuapp.com/api/v1/users/update?user=$id'),
        body: {
          "name": userNameController.text.trim(),
          "lastName": userNameController.text.trim(),
          "email": emailController.text.trim()
        });

    final data = jsonDecode(res.body);

   if(res.statusCode == 200){
     pref.setString('email', data['data']['user']['email']);
     pref.setString('number', data['data']['user']['number']);
     pref.setString('gender', data['data']['user']['gender']);
     pref.setString('name', data['data']['user']['name']);

     Navigator.pop(context);
     Fluttertoast.showToast(
       backgroundColor: Colors.blue,
       msg: "Profile Updated",
     );
   }else{
     Navigator.pop(context);
     Fluttertoast.showToast(
       backgroundColor: Colors.red,
       msg: data['message'],
     );
   }

  }

}
