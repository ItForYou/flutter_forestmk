import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class chat_webview extends StatefulWidget {

  String url;
  int view;
  chat_webview({Key key, this.url,this.view}) : super(key: key);

  @override
  _chat_webviewState createState() => _chat_webviewState();
}

class _chat_webviewState extends State<chat_webview> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  String current_url ="test";
  //WebViewController _webViewController;


  void presed_bak(){
      //구글 웹뷰 사용시
       /*   if(widget.view ==1){
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
          }*/
    if(widget.view ==1){
      Navigator.pop(context);
    }
    else {
      if (current_url.contains("chatting.php")) {
        flutterWebViewPlugin.evalJavascript("javascript:leavepage();");
      }
      else {
        Navigator.pop(context);
      }
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.onBack.listen((_){
      presed_bak();
    });
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        if(!url.contains("chatting")){
            presed_bak();
            flutterWebViewPlugin.close();
          }
        else {
          setState(() {
            current_url = url;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        presed_bak();
      },
      child:Scaffold(
        appBar: PreferredSize( child: Container(), preferredSize: Size.fromHeight(0.1),),
        body: WebviewScaffold(
          url: widget.url,
          withJavascript: true,
          withLocalStorage: true,
          appBar: null,
          javascriptChannels: Set.from([
            JavascriptChannel(
                name: 'goback',
                onMessageReceived: (JavascriptMessage message) async{
                  presed_bak();
                }
            ),
          ]),
        ),
      )

      //구글 웹뷰 사용시
      /* Scaffold(
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
      ),*/
    );
  }
}
