import 'package:covid/modules/RegisterScreen.dart';
import 'package:covid/modules/main_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // get edit texts values
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var _email_resetController= TextEditingController();
  var _phone_resetController= TextEditingController();

  // track password status
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0563c4),
        systemOverlayStyle:
            SystemUiOverlayStyle.light, // status bar text to light :)
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child:   Image.asset(
                          "assets/images/login.png",
                          //height: 250,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  cursorColor: Color(0xff0563c4),
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      hoverColor: Color(0xff0563c4),
                      iconColor: Color(0xff0563c4),
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color:Color(0xff0563c4)),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Color(0xff0563c4),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff0563c4),
                        ),
                      ),
                      focusColor: Color(0xff0563c4),
                      fillColor: Color(0xff0563c4)),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscure,
                  decoration:  InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Color(0xff0563c4)),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xff0563c4),
                      ),

                    suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.remove_red_eye : Icons.visibility_off_rounded,
                          color: Color(0xff0563c4),
                        ),
                        onPressed: () {
                            _isObscure = !_isObscure;
                            setState(() {});
                        },
                    ),

                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff0563c4),
                        ),
                      ),
                      focusColor: Color(0xff0563c4),
                      fillColor: Color(0xff0563c4)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // forgetPassword(context);
                        forgetPassword();
                      },
                      child: const Text(
                        'Forget Your password ?',
                        style: TextStyle(color: Color(0xff0563c4)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff0563c4),
                    ),

                    width: double.infinity,
                    // sign in
                    child: MaterialButton(
                      onPressed: () {
                          login();
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                    ),
                    TextButton(
                      onPressed: () {
                        // move to register page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                      },
                      child: const Text(
                        'Register Now',
                        style: TextStyle(color: Color(0xff0563c4)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// reset password
  forgetPassword(){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text('FORGET PASSWORD', style: TextStyle(color: Color(0xff0563c4))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                  },
                  controller: _email_resetController,
                  decoration:  InputDecoration(
                      hintText: "Enter your email address"

                  ),

),

                TextField(
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                  },
                  controller: _phone_resetController,
                  decoration:  InputDecoration(hintText: "Enter your phone number"),
                ),

              ],
            ),



            actions: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff0563c4),
                    ),
                    // width: double.infinity,
                    // sign in
                    child: MaterialButton(
                      onPressed: () {
                        verify();
                      },
                      child: const Text(
                        'VERIFY',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff0563c4),
                    ),
                  //  width: double.infinity,
                    // sign in
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],

          );
        });
  }

  /// restore password
  verify() async {
    var pref = await SharedPreferences.getInstance();
    var email = pref.getString('user_email');
    var phone = pref.getString('user_number');
    var password = pref.getString('user_password');

    if(email == _email_resetController.text.trim() &&
        phone == _phone_resetController.text.trim()){
      Navigator.pop(context);
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Color(0xff0563c4),
        msg: 'Your password: $password',
      );
    }else{
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: 'Invalid data!',
      );
    }
  }

  /*
    login method
   */
  void login() async{

    if(!(phoneController.text.trim().isEmpty || passwordController.text.trim().isEmpty)){

      showDialog(
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          context: context);
      var res = await http.post(
        Uri.parse('https://cough-api.herokuapp.com/api/v1/users/login'),
        headers: {},
        body: {
          "number": phoneController.text.trim(),
          "password": passwordController.text.trim()
        },
      );
      final data = json.decode(res.body);
      var pref = await SharedPreferences.getInstance();
      if(res.statusCode == 200){
        pref.setString('token', data['data']['token']);
        pref.setString('userId', data['data']['user']['_id']);
        pref.setString('isAdmin', data['data']['user']['isAdmin'].toString());
        pref.setString('email', data['data']['user']['email']);
        pref.setString('number', data['data']['user']['number']);
        pref.setString('gender', data['data']['user']['gender']);
        pref.setString('name', data['data']['user']['name']);
        Navigator.pop(context);
        Fluttertoast.showToast(
          backgroundColor: Color(0xff0563c4),
          msg: 'Login Successfully',
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MainPage()));
      }else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: data['message'],
        );
      }
    }else{
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: 'Fields required!',
      );
    }

    }

  }
