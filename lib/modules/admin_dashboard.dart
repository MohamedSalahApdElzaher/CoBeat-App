import 'dart:async';
import 'dart:convert';
import 'package:covid/modules/verified_samples.dart';
import 'package:covid/modules/web_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';


class admin_dashboard extends StatefulWidget {
  @override
  State<admin_dashboard> createState() => _admin_dashboard();
}

class _admin_dashboard extends State<admin_dashboard> {

  /// get all unverified samples from custom dataset
  var data;
  getHistory() async{
    var pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final res =
    await http.get(Uri.parse('https://cough-api.herokuapp.com/api/v1/samples/verifysample'),
        headers: {
          'Authorization': 'Bearer $token',
        });
    data = jsonDecode(res.body);
    return data;
  }

  /// verify sample
  var verify_data;
  verify_sample(id) async{
    var pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final res =
    await http.patch(Uri.parse('https://cough-api.herokuapp.com/api/v1/samples/verifysample?sampleID=$id'),
        headers: {
          'Authorization': 'Bearer $token',
        });
    verify_data = jsonDecode(res.body);
    if(res.statusCode == 200){
      Fluttertoast.showToast(
        backgroundColor: Color(0xff0563c4),
        msg: 'Sample Verified Successfully',
      );

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => verified_samples()));
    }else{
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: verify_data['message'],
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<dynamic>(
        future: getHistory(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            data = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xff0563c4),
                systemOverlayStyle: SystemUiOverlayStyle.light,
                elevation: 0,

                actions: [
                  IconButton(
                      iconSize: 30,
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => web_dashboard()));
                      },
                      icon: const Icon(
                        Icons.dashboard,
                        color: Colors.white,
                      )),

                  IconButton(
                      iconSize: 30,
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => verified_samples()));
                      },
                      icon: const Icon(
                        Icons.verified_user,
                        color: Colors.white,
                      )),
                ],

              ),
              backgroundColor: Colors.white,
              body:  Container(
                child: ListView.builder(
                  itemCount: data['data'].length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shadowColor: Colors.black,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _buildStatCard(
                                    'BREATH PROBLEM', data['data'][index]['breathProblem'].toString() == 'false' ? 'No' : 'Yes',
                                    Colors.red),
                                _buildStatCard(
                                    'FEVER',  data['data'][index]['fever'].toString() == 'false' ? 'No' : 'Yes', Colors.blue),
                              ],
                            ),
                            Row(
                              children: [
                                _buildStatCard('COVID STATUS',
                                    data['data'][index]['covid'].toString() == 'false' ? 'Negative' : 'Positive',
                                    Colors.orange),

                                _buildStatCard('DATE',
                                    data['data'][index]['createdAt'].substring(0, 10).toString(),
                                    Colors.purple),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Image.network(
                                  data['data'][index]['report'],
                                  height: 170,
                                  width: double.infinity,
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          content: Image.network(
                                            data['data'][index]['report'],
                                          ),
                                        );
                                      });

                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.lightBlue,
                                    ),
                                    // width: double.infinity,
                                    // sign in
                                    child: MaterialButton(
                                      onPressed: () {
                                         verify_sample(data['data'][index]['_id'].toString());
                                      },
                                      child: const Text(
                                        'VERIFIED  ✓',
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
                                      color: Colors.lightBlue,
                                    ),
                                    //  width: double.infinity,
                                    // sign in
                                    child: MaterialButton(
                                      onPressed: () {

                                      },
                                      child: const Text(
                                        'INCORRECT  ✘',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        margin: EdgeInsets.all(10),
                      ),
                    )

                    ;
                  },
                ),

              ),
            );

          } else {
            return Scaffold(
                appBar: AppBar(
                backgroundColor: Color(0xff0563c4),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0, // status bar text to light :)
          ),
          backgroundColor: Colors.white,
          body: Center(
                  child: CircularProgressIndicator(
                    valueColor:  AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
            );
          }
        }
    );

  }

  _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        height: 100,
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgrammCard(index) {
    return Container(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shadowColor: Colors.black,
        child: Column(
          children: [
            Row(
              children: [
                _buildStatCard(
                    'BREATH PROBLEM', 'false' == 'false' ? 'No' : 'Yes',
                    Colors.red),
                _buildStatCard(
                    'FEVER', 'false' == 'false' ? 'No' : 'Yes', Colors.blue),
              ],
            ),
            Row(
              children: [
                _buildStatCard('COVID STATUS',
                    'false' == 'false' ? 'Negative' : 'Positive',
                    Colors.orange),

                _buildStatCard('DATE',
                    '15/6/2022',
                    Colors.purple),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Image.asset(
                  "assets/images/rport.png",
                  height: 170,
                  width: double.infinity,
                ),
                onTap: () {
                  print('image');
                  // OpenFile.open(imageFile.path);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.lightBlue,
                    ),
                    // width: double.infinity,
                    // sign in
                    child: MaterialButton(
                      onPressed: () {

                      },
                      child: const Text(
                        'VERIFIED  ✓',
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
                      color: Colors.lightBlue,
                    ),
                    //  width: double.infinity,
                    // sign in
                    child: MaterialButton(
                      onPressed: () {

                      },
                      child: const Text(
                        'INCORRECT  ✘',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        margin: EdgeInsets.all(10),
      ),
    );
  }


}
