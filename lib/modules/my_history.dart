import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class my_history extends StatefulWidget {
  @override
  State<my_history> createState() => _my_history();
}

class _my_history extends State<my_history> {

  var data;

  /// get user history
   getHistory() async{
    var pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final res =
    await http.get(Uri.parse('https://cough-api.herokuapp.com/api/v1/samples/'),
        headers: {
          'Authorization': 'Bearer $token',
        });
     data = jsonDecode(res.body);
     return data;
  }

  @override
  void initState() {
    super.initState();
      getHistory();
      setState(() {});
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
                elevation: 0, // status bar text to light :)
              ),
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: ListView.builder(
                    itemCount: data['data']['samples'].length,
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
                              _buildStatCard('BREATH PROBLEM',
                                  data['data']['samples'][index]['breathProblem']
                                      .toString() == 'false' ? 'No' : 'Yes',
                                  Colors.red),
                              _buildStatCard('FEVER',
                                  data['data']['samples'][index]['fever']
                                      .toString() == 'false' ? 'No' : 'Yes',
                                  Colors.blue),
                            ],
                          ),
                          Row(
                            children: [
                              _buildStatCard('COVID STATUS',
                                  data['data']['samples'][index]['covid']
                                      .toString() == 'false'
                                      ? 'Negative'
                                      : 'Positive', Colors.orange),
                              _buildStatCard('DATE',
                                  data['data']['samples'][index]['createdAt']
                                      .substring(0, 10)
                                      .toString(), Colors.purple),
                            ],
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
                    },
                  ),
                ),
              ),
            );

          } else {

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xff0563c4),
                systemOverlayStyle: SystemUiOverlayStyle.light,
                elevation: 0,
              ),
              backgroundColor: Colors.white,
              body: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
              ),

            );

          }

        }
    );


//    return data['data']['samples'].length <= 0 ?
//
//     Scaffold(
//        appBar: AppBar(
//          backgroundColor: Color(0xff0563c4),
//          systemOverlayStyle: SystemUiOverlayStyle.light,
//          elevation: 0, // status bar text to light :)
//        ),
//        backgroundColor: Colors.white,
//      body: Center(
//        child: Text('No History Found',
//          style: TextStyle(fontWeight: FontWeight.bold),
//        ),
//      ),
//    )
//
//    :



  }

   _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        height: 150,
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(5.0),
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
                fontSize: 16.0,
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


}
