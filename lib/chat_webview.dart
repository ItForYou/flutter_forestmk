import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
   // print(current_url);
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
      Navigator.pop(context,"change");
    }
    else {
      if (current_url.contains("chatting.php")) {
     //   print("pressed_back_javascript!");
        flutterWebViewPlugin.evalJavascript("javascript:leavepage();");
      }
      else {
        Navigator.pop(context,"change");
        flutterWebViewPlugin.stopLoading();
        flutterWebViewPlugin.dispose();

      }
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
   // print(widget.url);
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.onBack.listen((_){

      if (current_url.contains("chatting.php")) {
        print("back2!!");
        presed_bak();
      }
    });
    flutterWebViewPlugin.onUrlChanged.listen((String url){
      print("test_url"+url);
      if (mounted){
        if(!url.contains("chatting") && !url.contains("mb_id") ){
           // presed_bak();
            print("back1!!");
           // print("urlchange: "+url);
            flutterWebViewPlugin.close();
            presed_bak();
          }
        else if(current_url.contains("chatting.php")){
          print("test_back!");
          flutterWebViewPlugin.evalJavascript("javascript:leavepage();");
          //presed_bak();
        }
            current_url = url;
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
   // _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        print("back3!");
        presed_bak();
      },
      child: Scaffold(
          appBar: PreferredSize( child: Container(), preferredSize: Size.fromHeight(0.1),),
          body: WebviewScaffold(
           /* initialChild: Container(
              child: Text("Loadding....."),
            ),*/
            url: widget.url,
            withJavascript: true,
            withZoom: false,
            withLocalStorage: true,
            hidden: true,
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'goback',
                  onMessageReceived: (JavascriptMessage message) async{
                    presed_bak();
                  }
              ),
            ]),
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
      ),
    );

  }
}
