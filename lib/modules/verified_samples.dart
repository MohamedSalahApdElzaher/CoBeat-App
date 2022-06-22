import 'dart:async';
import 'dart:convert';
import 'package:covid/modules/web_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';


class verified_samples extends StatefulWidget {
  @override
  State<verified_samples> createState() => _verified_samples();
}

class _verified_samples extends State<verified_samples> {

  /// get history from custom dataset
  var data;
  getHistory() async{
    var pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final res =
    await http.get(Uri.parse('https://cough-api.herokuapp.com/api/v1/samples/dataset'),
        headers: {
          'Authorization': 'Bearer $token',
        });
    data = jsonDecode(res.body);
    return data;
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
}
