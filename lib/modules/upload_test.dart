import 'dart:async';
import 'dart:io';
import 'package:covid/modules/main_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../views/recorded_list_view.dart';
import '../views/recorder_view.dart';
import 'package:http/http.dart' as http;

class upload_test extends StatefulWidget {
  const upload_test({Key? key}) : super(key: key);

  @override
  State<upload_test> createState() => _upload_test();
}

class _upload_test extends State<upload_test> {
// radio buttons choices
  bool group_1 = false, group_2 = false , group_3 = false;
  bool? value = false;
  var file, fileName, filePath;

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
    clearData();
  }

  clearData() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString('filePath', '');
    pref.setString('fileName', '');
  }

  getData() async {
    var pref = await SharedPreferences.getInstance();
    filePath = pref.get('filePath');
    fileName = pref.get('fileName');
    setState(() {});
  }

  @override
  void dispose() {
    appDirectory.delete();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    getData();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0563c4),
          systemOverlayStyle:
          SystemUiOverlayStyle.light,
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
                              'Did you make PCR test before ?\nUpload your result and help us to grow our data set.',
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

                            const Text(
                              'Covid-19 status ?',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            Row(children: [
                              Radio(
                                value: true,
                                groupValue: group_3,
                                onChanged: (_) {
                                  setState(() {
                                    group_3 = true;
                                  });
                                },
                                activeColor: Color(0xff0563c4),
                              ),
                              const Text(
                                'Positive',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(
                                width: 44.5,
                              ),
                              Radio(
                                value: false,
                                groupValue: group_3,
                                onChanged: (_) {
                                  setState(() {
                                    group_3 = false;
                                  });
                                },
                                activeColor: Color(0xff0563c4),
                              ),
                              const Text(
                                'Negative',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ]),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Upload PCR test Image',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                   pickFile();
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.upload_file,
                                      size: 50,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Text(
                                fileName == null ? '' : fileName.toString(),
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

  /// upload sample
  Future<void> submitSample(BuildContext context) async {

    var pref = await SharedPreferences.getInstance();

    if(! (pref.getString('recordFile').toString().trim().isEmpty || pref.getString('filePath').toString().trim().isEmpty)){

      /// start processing
      Fluttertoast.showToast(
        backgroundColor: Color(0xff0563c4),
        msg: "Please wait...",
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
      String imagePath = pref.getString('filePath').toString();
      print(imagePath);
      final fever = group_1;
      final breathProblem = group_2;
      final covid = group_3;

      const url = 'https://cough-api.herokuapp.com/api/v1/samples/addtocustomdataset';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['fever'] = fever.toString();
      request.fields['breathProblem'] = breathProblem.toString();
      request.fields['covid'] = covid.toString();

      request.files.add(await http.MultipartFile.fromPath('sample', filePath));
      request.files.add(await http.MultipartFile.fromPath('report', imagePath));

      final token = pref.getString('token');

      request.headers.addAll({"Authorization": "Bearer $token"});

      http.Response response =
      await http.Response.fromStream(await request.send());

      final data = json.decode(response.body);

      if(response.statusCode == 201){
        Navigator.pop(context);
        Fluttertoast.showToast(
          backgroundColor: Colors.blue,
          msg: 'Thanks for submitting',
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

  // upload image
  pickFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null) file = '' ;
    file = result?.files.first;
    //openFile(file);
    var pref = await SharedPreferences.getInstance();
    pref.setString('filePath', file.path);
    pref.setString('fileName', file.name);
    setState(() {});
   }

   openFile(PlatformFile file){
     OpenFile.open(file.path);
   }

}
