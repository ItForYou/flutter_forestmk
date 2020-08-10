import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;

class chat_webview extends StatefulWidget {

  String url,mb_id,room_id;
  int view;

  chat_webview({Key key, this.url,this.view,  this.mb_id, this.room_id}) : super(key: key);

  @override
  _chat_webviewState createState() => _chat_webviewState();
}

class _chat_webviewState extends State<chat_webview> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  String current_url ="test",current_url2 ="test";
  String url, room_id;
  var itemdata;
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


      if (current_url2.contains("chatting.php")) {
          flutterWebViewPlugin.reloadUrl("http://14.48.175.177/bbs/chatting.list.php");
        // print("pressed_back_javascript!");
        //flutterWebViewPlugin.evalJavascript("javascript:leavepage();");
      }
      else {
        Navigator.pop(context,"change");
        flutterWebViewPlugin.stopLoading();
        flutterWebViewPlugin.dispose();
      }

  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.url!=null) {
      url = widget.url;
    }
    if(widget.room_id !=null){
      room_id = widget.room_id;
    }
   // print(widget.url);
    flutterWebViewPlugin.close();

    flutterWebViewPlugin.onBack.listen((_){

        print("onback2!!");
      if (current_url.contains("chatting.php")) {
        print("back2!!");
        //presed_bak();
      }

    });

    flutterWebViewPlugin.onUrlChanged.listen((String url){

        if (url.contains("chatting.php")) {
            print("chatting.php");
            //글아이디+채팅 신청자 아이디
            if(url.contains("room_id=")){

            }

            int temp_str_idx = url.indexOf("room_id=");
            String temp_str = url.substring(temp_str_idx,url.length);

            if(temp_str.contains("&")){
              int str_idx = temp_str.indexOf("&");
              String temp_str2 = temp_str.substring(0,str_idx);
              room_id = temp_str2;
            }
            else{
              room_id = temp_str;
            }
            upload_state(1);
        //presed_bak();
        }

       else if(!url.contains("chatting") && !url.contains("mb_id") ){
          print("not chatting.php");
           // presed_bak();
           // print("urlchange: "+url);
            flutterWebViewPlugin.close();
            presed_bak();
       }

       else if(current_url2.contains("chatting.php")){
         print("chatting.php2");
         int temp_str_idx = current_url2.indexOf("room_id=");
         String temp_str = current_url2.substring(temp_str_idx,current_url2.length);

         if(temp_str.contains("&")){
           int str_idx = temp_str.indexOf("&");
           String temp_str2 = temp_str.substring(0,str_idx);
           room_id = temp_str2;
         }
         else{
           room_id = temp_str;
         }
          upload_state(0);
      //    flutterWebViewPlugin.reloadUrl("http://14.48.175.177/bbs/chatting.list.php");
        }

       else if(current_url2.contains("chatting.list.php")){
          Navigator.pop(context,"change");
          flutterWebViewPlugin.stopLoading();
          flutterWebViewPlugin.dispose();
        }

        current_url2= url;

    });

  }

  Future<dynamic> upload_state(flg) async{
    //  print("test_getdata"+mb_id);
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/ajax.update_statechat.php'),
        body: {
          "mb_id":widget.mb_id==null?'':widget.mb_id,
          "room_id":room_id==null?'':room_id,
          "flg":flg.toString(),
        },
        headers: {'Accept' : 'application/json'}
    );

    //print(response.body);
  /*  setState(() {
      flutterWebViewPlugin.reload();
    });*/

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

            url: url,
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
