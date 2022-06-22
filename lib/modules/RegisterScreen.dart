import 'package:covid/modules/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<RegisterScreen> {

  // track password / confirm status
  bool _isObscure = true , _isObscure_ = true;

  // controllers to get values
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var confirmpasswordController = TextEditingController();
  var _codeController = TextEditingController();


  var formKey = GlobalKey<FormState>();
  dynamic group_1 = 1;

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
                    child: Form(
                        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              key: formKey,
              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child:   Image.asset(
                          "assets/images/sign-up.jpg",
                        ),
                      ),

                  ],
                ),

                const SizedBox(
                  height: 15.0,
                ),
                //userName
                TextFormField(
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
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: Color(0xff0563c4)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:  BorderSide(
                        color: Color(0xff0563c4),
                      ),
                    ),
                    prefixIcon:  Icon(
                      Icons.email,
                      color:Color(0xff0563c4),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20.0,
                ),
                //password
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscure,
                  decoration:  InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Color(0xff0563c4)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff0563c4),
                      ),
                    ),
                    prefixIcon: Icon(
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
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                //confirmPassword
                TextFormField(
                  controller: confirmpasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscure_,
                  decoration:  InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Color(0xff0563c4)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff0563c4),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0xff0563c4),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure_ ? Icons.remove_red_eye : Icons.visibility_off_rounded,
                        color: Color(0xff0563c4),
                      ),
                      onPressed: () {
                        _isObscure_ = !_isObscure_;
                        setState(() {});
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20.0,
                ),
                //phone
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color:Color(0xff0563c4)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:  BorderSide(
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
                //gender
                const Text(
                  'Gender',
                  style:  TextStyle(
                    fontSize: 20.0,
                    color: Color(0xff0563c4)
                  ),
                ),
                Row(children: [
                  Radio(
                    value: "male",
                    groupValue: group_1,
                    onChanged: (_) {
                      setState(() {
                        group_1 = "male";
                      });
                    },
                    activeColor: Color(0xff0563c4),
                  ),
                  const Text(
                    'Male',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xff0563c4),
                    ),
                  ),
                  const SizedBox(
                    width: 90.0,
                  ),
                  Radio(
                    value: "female",
                    groupValue: group_1,
                    onChanged: (_) {
                      setState(() {
                        group_1 = "female";
                      });
                    },
                    activeColor: Color(0xff0563c4),
                  ),
                  const Text(
                    'Female',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xff0563c4)
                    ),
                  ),
                ]),

                const SizedBox(
                  height: 20.0,
                ),

                //register button
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color:  Color(0xff0563c4),
                    ),
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                         register();
                      },
                      child: const Text(
                        'Register',
                        style:  TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ))))));
  }

  /*
    register method
   */
  void register() async{

    if(!(phoneController.text.trim().isEmpty || passwordController.text.trim().isEmpty
      || userNameController.text.trim().isEmpty || confirmpasswordController.text.trim().isEmpty
     || group_1 == 1)){

      showDialog(
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          context: context);

      var res = await http.post(
        Uri.parse('https://cough-api.herokuapp.com/api/v1/users/'),
        headers: {},
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "confirmPassword": confirmpasswordController.text.trim(),
          "number": phoneController.text.trim(),
          "gender": group_1,
          "name": userNameController.text.trim(),
          "lastName": userNameController.text.trim()
        },
      );

      final data = json.decode(res.body);

      if(res.statusCode == 200){
        userData(); // save user data
        Navigator.pop(context);
        Fluttertoast.showToast(
          backgroundColor:Color(0xff0563c4),
          msg: 'Register Successfully',
        );

        // send code to user and verify it
        sendCode(data['data']['user']['_id']);

      }else{
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

  // save user data
  userData()async{
    var pref = await SharedPreferences.getInstance();
    pref.setString('user_email', emailController.text.trim());
    pref.setString('user_number', phoneController.text.trim());
    pref.setString('user_password', passwordController.text.trim());
  }

  /// send code to user phone
  Future<void> sendCode(id) async {

    /// send code to user
    var codeRes = await http.post(
      Uri.parse('https://cough-api.herokuapp.com/api/v1/users/message?user=$id'),
    );

    final verifiedData = json.decode(codeRes.body);

    if(codeRes.statusCode == 200){
      Fluttertoast.showToast(
        backgroundColor: Colors.orangeAccent,
        msg: 'We just SMS you with a verification code',
      );

      // verify user code
      codeVerifyDialog(context, id);

    }else{
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: verifiedData['message'],
      );
    }
  }

  /// verification code for user
  Future<void> codeVerifyDialog(BuildContext context, id) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text('VERIFICATION', style: TextStyle(color: Color(0xff0563c4))),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
              },
              controller: _codeController,
              decoration: const InputDecoration(hintText: "Enter verification code"),
            ),
            actions: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff0563c4),
                    ),
                    // width: double.infinity,
                    // sign in
                    child: MaterialButton(
                      onPressed: () async{

                        showDialog(
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(
                                valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            context: context);

                        if(_codeController.text.trim().isEmpty){
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            backgroundColor: Colors.red,
                            msg: "Please Enter Code",
                          );

                        }else{

                          var res = await http.post(
                            Uri.parse('https://cough-api.herokuapp.com/api/v1/users/verify?user=$id'),
                            body: {
                              "code": _codeController.text.trim(),
                            },
                          );

                          final verifiedData = json.decode(res.body);

                          if(res.statusCode == 200){
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              backgroundColor: Color(0xff0563c4),
                              msg: 'Verified!',
                            );

                            // go to login page
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => LoginScreen()));

                          }else{
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              backgroundColor: Colors.red,
                              msg: verifiedData['message'],
                            );

                            /// send code again
                            sendCode(id);

                          }

                        }

                      },
                      child: const Text(
                        'VERIFY',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

//              FlatButton(
//                child: const Text("verify", style: TextStyle(color: Colors.deepOrange),),
//                onPressed: () async {
//
//                  showDialog(
//                      barrierDismissible: false,
//                      builder: (context) => const Center(
//                        child: CircularProgressIndicator(
//                          valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
//                        ),
//                      ),
//                      context: context);
//
//                  if(_codeController.text.trim().isEmpty){
//                    Navigator.pop(context);
//                    Fluttertoast.showToast(
//                      backgroundColor: Colors.red,
//                      msg: "Please Enter Code",
//                    );
//
//                  }else{
//
//                    var res = await http.post(
//                      Uri.parse('https://cough-api.herokuapp.com/api/v1/users/verify?user=$id'),
//                      body: {
//                        "code": _codeController.text.trim(),
//                      },
//                    );
//
//                    final verifiedData = json.decode(res.body);
//
//                    if(res.statusCode == 200){
//                      Navigator.pop(context);
//                      Fluttertoast.showToast(
//                        backgroundColor: Color(0xff0563c4),
//                        msg: 'Verified!',
//                      );
//
//                      // go to login page
//                      Navigator.of(context).pushReplacement(MaterialPageRoute(
//                          builder: (context) => LoginScreen()));
//
//                    }else{
//                      Navigator.pop(context);
//                      Fluttertoast.showToast(
//                        backgroundColor: Colors.red,
//                        msg: verifiedData['message'],
//                      );
//                    }
//
//                  }
//                },
//              ),

            ],

          );
        });
  }



}