import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';


class chat_webview extends StatefulWidget {

  String url;
  int view;
  chat_webview({Key key, this.url,this.view}) : super(key: key);

  @override
  _chat_webviewState createState() => _chat_webviewState();
}

class _chat_webviewState extends State<chat_webview> {
  WebViewController _webViewController;


  void presed_bak(){

          if(widget.view ==1){
            Navigator.pop(context);
          }
          else {
            _webViewController.currentUrl().then((String value) {
              if (value.contains("chatting.php")) {
                _webViewController.evaluateJavascript(
                    "javascript:leavepage();");
              }
              else {
                Navigator.pop(context);
              }
            });
          }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        presed_bak();
      },
      child: Scaffold(
        appBar: null,
        body: SafeArea(
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
          ),
        ),

      ),
    );
  }
}
