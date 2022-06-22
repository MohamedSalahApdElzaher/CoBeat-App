import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class covid_report extends StatefulWidget {
  @override
  _covid_report createState() => _covid_report();
}

class _covid_report extends State<covid_report> {

  String covid='',fever='',breathProblem='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
    getHistory();
  }

  /// get user history
  void getHistory() async{
    var pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final res =
    await http.get(Uri.parse('https://cough-api.herokuapp.com/api/v1/samples/'),
        headers: {
          'Authorization': 'Bearer $token',
        });
    final d = jsonDecode(res.body);
    final rec = d['data']['samples'].last;
    pref.setString('last_record_updated_at', rec['updatedAt']);
  }

  check() async {
    var pref = await SharedPreferences.getInstance();
    covid = pref.getString('covid').toString();
    fever = pref.getString('fever').toString();
    breathProblem = pref.getString('breathProblem').toString();
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return covid == 'null' || fever.isEmpty || breathProblem.isEmpty ?
    Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0563c4),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0, // status bar text to light :)
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          "You don't have any test report",
          style: TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 15.0),
          textAlign: TextAlign.center,
        ),
      ),
    )
        :
    Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0563c4),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0, // status bar text to light :)
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                         Text('COVID-19 TEST REPORT',
                         style: TextStyle(color: Color(0xff0563c4), fontWeight: FontWeight.bold),)
                      ],
                    ),

                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          child: Row(
                            children: <Widget>[
                              _buildStatCard(
                                  'BREATH PROBLEM', breathProblem == 'false' ? 'No' : 'Yes', Colors.orange),
                              _buildStatCard('FEVER', fever == 'false' ? 'No' : 'Yes', Colors.red),
                            ],
                          ),
                        ),

                      ],
                    ),

                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          child: Row(
                            children: <Widget>[
                              _buildStatCard(
                                  'COVID-19 STATUS',
                                  covid == 'false' ? 'Negative' : 'Positive', Colors.lightBlue),
                            ],
                          ),
                        ),

                      ],
                    ),

                  ),
                ),
              ),

            ],

          ),

    );

  }

  Expanded _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(15.0),
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
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
