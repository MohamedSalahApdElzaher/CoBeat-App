import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';


class web_dashboard extends StatefulWidget {
  @override
  State<web_dashboard> createState() => _web_dashboard();
}

class _web_dashboard extends State<web_dashboard> {

  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xff0563c4),
                systemOverlayStyle: SystemUiOverlayStyle.light,
                elevation: 0,
              ),
              backgroundColor: Colors.white,
              body:  Container(
                child:  Center(
                    child: WebView(
                    initialUrl: 'http://cough-api.herokuapp.com/admin',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                    _controller = webViewController;
                    },
                    ),

              ),
              ),

            );

  }


}
