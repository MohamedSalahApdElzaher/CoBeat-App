import 'dart:convert';

import 'package:covid/modules/LoginScreen.dart';
import 'package:covid/modules/Tracker.dart';
import 'package:covid/modules/about_us.dart';
import 'package:covid/modules/admin_dashboard.dart';
import 'package:covid/modules/covid_report.dart';
import 'package:covid/modules/my_history.dart';
import 'package:covid/modules/profile.dart';
import 'package:covid/modules/upload_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Data.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // check user status
  bool signed = false, hasResult = false, isAdmin = false;

  @override
  void initState() {
    super.initState();
    check();
    getHistory();
    setState(() {});
  }

  /// get user history
  void getHistory() async {
    var pref = await SharedPreferences.getInstance();
    final token = (pref.getString('token').toString());

    final res = await http.get(
        Uri.parse('https://cough-api.herokuapp.com/api/v1/samples/'),
        headers: {
          'Authorization': 'Bearer $token',
        });

    final data = jsonDecode(res.body);

    String oldRecord = pref.get('last_record_updated_at').toString();
    final newRecord = data['data']['samples'].last;
    if (oldRecord == newRecord['updatedAt']) {
      hasResult = false;
      setState(() {});
    } else {
      hasResult = true;
      setState(() {});
    }
  }

  /// get user token
  void check() async {
    var pref = await SharedPreferences.getInstance();
    signed = (pref.getString('token').toString().isEmpty) ? false : true;
    isAdmin = (pref.getString('isAdmin').toString() == 'true') ? true : false;
    setState(() {});
  }

  /// move to covid_report
  submit() async {
    /**
     * check user status
     */
    var pref = await SharedPreferences.getInstance();
    (pref.getString('token').toString().isEmpty)
        ? Fluttertoast.showToast(
            backgroundColor: Colors.red,
            msg: 'Test Result Require Login',
          )
        : Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => covid_report()));
  }

  @override
  build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle.light, // status bar text to light :)
          backgroundColor: Color(0xff0563c4),
          elevation: 0,
          // check user status
          leading: signed
              ?
              // logout
              IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    var pref = await SharedPreferences.getInstance();
                    pref.setString('token', '');
                    pref.setString('isAdmin', '');
                    Fluttertoast.showToast(
                      backgroundColor: Colors.deepOrange,
                      msg: 'Sign Out Successfully',
                    );

                    check();
                  })
              :
              // login
              IconButton(
                  iconSize: 30,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  icon: const Icon(
                    Icons.login,
                    color: Colors.white,
                  )),

          actions: [

            isAdmin ?

            IconButton(
                iconSize: 30,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => admin_dashboard()));
                },
                icon: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                ))

            :

            IconButton(
                icon: const Icon(
                  Icons.admin_panel_settings,
                  color: Color(0xff0563c4),
                ), onPressed: () {  },),

            myAppBarIcon(),

            PopupMenuButton(
              onSelected: (result) async {
                if (result == 1) {
                     myHistory();
                }else if(result == 2){
                     uploadStatus();
                }else if(result == 3){
                    deleteAccount();
                }

              },
              shape: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.white,
              )),
              color: Color(0xff0563c4),
              itemBuilder: (context) => [

                PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                    title: Text(
                      'My History',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: Icon(
                      Icons.cloud_upload,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Upload PCR Result',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                PopupMenuItem(
                  value: 3,
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              ],
            ),

          ],
        ),
        body: TabBarView(
          children: <Widget>[
            HomePage(),
            Tracker(),
            profile(),
            aboutUs(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 6),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade300,
              indicator: BoxDecoration(
                color: Color(0xff0563c4),
                borderRadius: BorderRadius.circular(40),
              ),
              tabs: const <Widget>[
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.assessment),
                ),
                Tab(
                  icon: Icon(Icons.supervised_user_circle),
                ),
                Tab(
                  icon: Icon(Icons.help),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // custom appbar
  Widget myAppBarIcon() {
    getHistory();

    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: GestureDetector(
        onTap: () {
          submit();
        },
        child: Container(
          width: 30,
          height: 30,
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Icon(
                  Icons.assignment_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              // if true show notifications

              hasResult
                  ? Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 12),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xffc32c37),
                            border: Border.all(color: Colors.white, width: 1)),
                        child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      child: Container(
                        child: Container(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  deleteAccount(){
    if(!signed){
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: 'Please Login First',
      );
    }else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: const Text(
                  'DELETE ACCOUNT', style: TextStyle(color: Color(0xff0563c4))),
              content: Text('Are you sure ?'),
              actions: <Widget>[

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red,
                      ),
                      // width: double.infinity,
                      // sign in
                      child: MaterialButton(
                        onPressed: () async {
                          showDialog(
                              builder: (context) =>
                              const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              context: context);

                          var pref = await SharedPreferences.getInstance();
                          var id = pref.get('userId');

                          var res = await http.delete(
                            Uri.parse(
                                'https://cough-api.herokuapp.com/api/v1/users/delete?user=$id'),
                          );

                          final data = json.decode(res.body);

                          if (res.statusCode == 200) {
                            Navigator.of(context).pop();
                            pref.setString('token', '');
                            check();
                            Fluttertoast.showToast(
                              backgroundColor: Color(0xff0563c4),
                              msg: 'Account deleted Successfully',
                            );
                          }
                          else {
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                              backgroundColor: Colors.red,
                              msg: data['message'],
                            );
                          }

                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'DELETE',
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
  }

   myHistory() {
      if(!signed){
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: 'Please Login First',
        );
      }else{
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>  my_history()));
      }
   }

   uploadStatus() async{
     if(!signed){
       Fluttertoast.showToast(
         backgroundColor: Colors.red,
         msg: 'Please Login First',
       );
     }else{
       var pref = await SharedPreferences.getInstance();
       pref.setString('recordFile', '');
       pref.setString('filePath', '');
       Navigator.of(context)
           .push(MaterialPageRoute(builder: (context) =>  upload_test()));
     }
   }


}
