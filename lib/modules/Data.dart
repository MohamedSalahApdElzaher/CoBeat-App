import 'dart:async';
import 'dart:io';
import 'package:covid/modules/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../views/recorded_list_view.dart';
import '../views/recorder_view.dart';
import 'package:http/http.dart' as http;

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  State<Data> createState() => _Data();
}

class _Data extends State<Data> {
// radio buttons choices
  bool group_1 = false;
  bool group_2 = false;
  bool? value = false;

  late Directory appDirectory;
  List<String> records = [];

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) {
          records.add(onData.path);
        }
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    appDirectory.delete();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0563c4),
          systemOverlayStyle:
              SystemUiOverlayStyle.light,
          actions: [
            IconButton(
                iconSize: 30,
                onPressed: () {
                  guid(context);
                },
                icon: const Icon(
                  Icons.help,
                  color: Colors.white,
                )),

          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
                        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'In order to make test\nMetadata is essential to provide accurate test\nit\'s private and only takes about 1 min',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                //are u smoke? value2
                const Text(
                  'Do you have a fever ?',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Row(children: [
                  Radio(
                    value: true,
                    groupValue: group_1,
                    onChanged: (_) {
                      setState(() {
                        group_1 = true;
                      });
                    },
                    activeColor: Color(0xff0563c4),
                  ),
                  const Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(
                    width: 90.0,
                  ),
                  Radio(
                    value: false,
                    groupValue: group_1,
                    onChanged: (_) {
                      setState(() {
                        group_1 = false;
                      });
                    },
                    activeColor: Color(0xff0563c4),
                  ),
                  const Text(
                    'No',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ]),

                const SizedBox(
                  height: 15.0,
                ),

                //vaccine
                const Text(
                  'Do you have a breath problem ?',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Row(children: [
                  Radio(
                    value: true,
                    groupValue: group_2,
                    onChanged: (_) {
                      setState(() {
                        group_2 = true;
                      });
                    },
                    activeColor: Color(0xff0563c4),
                  ),
                  const Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(
                    width: 44.5,
                  ),
                  Radio(
                    value: false,
                    groupValue: group_2,
                    onChanged: (_) {
                      setState(() {
                        group_2 = false;
                      });
                    },
                    activeColor: Color(0xff0563c4),
                  ),
                  const Text(
                    'No',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ]),

                const SizedBox(
                  height: 15.0,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150.0,
                      child: RecordListView(
                        records: records,
                      ),
                    ),
                    RecorderView(
                      onSaved: _onRecordComplete,
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.all(5.0),
                ),

                const SizedBox(
                  height: 15.0,
                ),

                //register button
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xff0563c4),
                    ),
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        // upload sample data for test
                          submitSample(context);
                      },
                      child: const Text(
                        'SUBMIT',
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

  /// get user history | last record val
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

  /// upload sample
  Future<void> submitSample(BuildContext context) async {
    /// store old values to be compared
    getHistory();

    var pref = await SharedPreferences.getInstance();

    if(! pref.getString('recordFile').toString().trim().isEmpty){

      /// start processing
      Fluttertoast.showToast(
        backgroundColor: Color(0xff0563c4),
        msg: "Please wait until processing finish",
      );

      showDialog(
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          context: context);

      /// get record file path
      String filePath = pref.getString('recordFile').toString();
      final fever = group_1;
      final breathProblem = group_2;

      const url = 'https://cough-api.herokuapp.com/api/v1/samples/';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['fever'] = fever.toString();
      request.fields['breathProblem'] = breathProblem.toString();

      request.files.add(await http.MultipartFile.fromPath('sample', filePath));

      final token = pref.getString('token');

      request.headers.addAll({"Authorization": "Bearer $token"});

      http.Response response =
      await http.Response.fromStream(await request.send());

      final data = json.decode(response.body);

      if(response.statusCode == 201){
        Navigator.pop(context);
        pref.setString('covid', data['data']['covid'].toString());
        pref.setString('fever', fever.toString());
        pref.setString('breathProblem', breathProblem.toString());
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: 'We will notify you once your result be ready',
        );
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MainPage()));
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

  /// complete recording
  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      setState(() {});
    });
  }

  guid(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text('TEST GUIDE'),

            content: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        "assets/images/usersick.png",
                        height: 80,
                        width: 80,
                      ),

                    ),
                    SizedBox(height: 15.0,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        "assets/images/arraw.PNG",
                        height: 50,
                        width: 50,
                      ),

                    ),
                    SizedBox(height: 15.0,),

                    Text('Answer questions', style: TextStyle(fontWeight: FontWeight.normal),),
                    SizedBox(height: 15.0,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        "assets/images/arraw.PNG",
                        height: 50,
                        width: 50,
                      ),
                    ),

                    SizedBox(height: 15.0,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            "assets/images/record.png",
                            height: 60,
                            width: 60,
                          ),

                        ),

                    SizedBox(height: 10.0,),
                    Text('Start recording'),
                    SizedBox(height: 15.0,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        "assets/images/arraw.PNG",
                        height: 50,
                        width: 50,
                      ),
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        "assets/images/usercoush.png",
                        height: 80,
                        width: 80,
                      ),

                    ),
                    SizedBox(height: 10.0,),
                    Text('Cough'),
                    SizedBox(height: 15.0,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        "assets/images/arraw.PNG",
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Text('Stop recording and click submit', style: TextStyle(fontWeight: FontWeight.normal),),

                  ],

                ),
              ),
            ),

          );
        });
  }

  
}
