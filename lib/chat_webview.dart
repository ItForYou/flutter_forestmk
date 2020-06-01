import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';


class chat_webview extends StatefulWidget {

  String url;
  chat_webview({Key key, this.url}) : super(key: key);

  @override
  _chat_webviewState createState() => _chat_webviewState();
}

class _chat_webviewState extends State<chat_webview> {
  WebViewController _webViewController;


  void presed_bak(){
      _webViewController.canGoBack().then((bool value) {
          if(value ==false) {
            _webViewController.currentUrl().then((String value) {
              if (value.contains("chatting.php")) {
                _webViewController.evaluateJavascript(
                    "javascript:leavepage();");
                Navigator.pop(context);
              }
              else
                Navigator.pop(context);
            });
          }
          else{
            _webViewController.evaluateJavascript("javascript:leavepage();");
          }
      });

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
