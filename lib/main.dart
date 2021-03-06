

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterforestmk/categorypage.dart';
import 'package:flutterforestmk/chat_webview.dart';
import 'package:flutterforestmk/chk_writead.dart';
import 'package:flutterforestmk/location.dart';
import 'package:flutterforestmk/member/loginpage.dart';
import 'package:flutterforestmk/main_item.dart';
import 'package:flutterforestmk/member/my_items.dart';
import 'package:flutterforestmk/member/register.dart';
import 'package:flutterforestmk/search_main.dart';
import 'package:flutterforestmk/splash.dart';
import 'package:flutterforestmk/border/write_normal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutterforestmk/border/viewpage.dart';
import 'package:flutterforestmk/member/mypage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


/*Future <void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  var initAndroidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = IOSInitializationSettings();
  var initSetting = InitializationSettings(initAndroidSetting, initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting, onSelectNotification: (String value) async{

    var result = await Navigator.push(
        context, MaterialPageRoute(
        builder: (context) =>
            chat_webview(
              url: "http://14.48.175.177/bbs/login_check.php?mb_id=" +
                  mb_id + "&mb_password=" +
                  mb_pwd+ "&flg_view=1&view_id="+message['data']['flutter_go'],view: 1,
            )
    ));
    if (result == 'change') {
      get_data();
    }

  });
  runApp(MyApp());

}*/

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}


class MyApp extends StatefulWidget {

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();

}

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyHomePage()),
            (Route<dynamic> route) => false);
  //  Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(//이미지 꾸미기
              fit:BoxFit.fitHeight,
              //image:  AssetImage("images/wing_mb_noimg2.png"),
              image: AssetImage("images/splash.png")
          )
      ),
    );
  }
}


Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print("test_callbackground");
/*  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(notification);
  }
  // Or do other work.*/
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: '숲마켓',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.forestmk,

        ),

        home: splash(),
        //home: MyHomePage(title: '숲마켓', ),

    );

  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title,}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool checkbox_soldout = false;
  bool checkbox_adv = false;
  ScrollController change_appbar = ScrollController();
  TextEditingController search_text = new TextEditingController();
  main_item item;
  int start_height=1,flg_floatbt=0;
   double list_height;
  static double scrollbar_height=1;
  PreferredSize appbar;
  String count_msg = "0";
  Widget head_first, mb_infowidget=Text("로그인 후, 이용해주세요",style: TextStyle(fontSize:12,color: Color(0xff888888)));
  bool flg_search = false, flg_pushchat=false;
  String sort_value = "최근순", mb_id,mb_pwd,mb_2="test",mb_1="test",mb_name="test",mb_hp,mb_3,mb_4,mb_5='',mb_6='';
  var itemdata;
  List <Widget> items_content=[];
  int build_cnt = 0;
  int count_chatview =0;

  PreferredSize intro_appbar = PreferredSize(
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
      preferredSize:Size.fromHeight(0),
      child:AppBar(
        title: null,
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions:null,
      )
  );
  PreferredSize scroll_appbar;

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Future <void> initlocalnotice() async{

  WidgetsFlutterBinding.ensureInitialized();
  var initAndroidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = IOSInitializationSettings();
  var initSetting = InitializationSettings(initAndroidSetting, initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting, onSelectNotification: (String value) async{

      if(value =='댓글'){

      }
      else {
      if(mb_id!=null) {
        count_chatview ++;
    /*    var result = await Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                chat_webview(
                    url: "http://14.48.175.177/bbs/login_check.php?mb_id=" +
                        mb_id + "&mb_password=" + mb_pwd + "&flg_flutter=1")
        ));
        //       print("onLaunch - "+result);
        if (result == 'change') {
         // print("test_back chat");
          if(count_chatview>1) {
            for(int i =0; i< count_chatview-1; i++) {
              Navigator.pop(context);
            }
            count_chatview=0;
          }

          get_cntchat();
          get_data();
        }
        */
        var result = await Navigator.push(
            context, MaterialPageRoute(
            builder: (context) =>
                chat_webview(
                  url: "http://14.48.175.177/bbs/login_check.php?mb_id=" +
                      mb_id + "&mb_password=" +
                      mb_pwd + "&flg_view=1&view_id=" + value, view: 1,mb_id: mb_id,room_id: value,
                )
        ));
        if (result == 'change') {
          // print("test_back chat");
          if(count_chatview>1) {
            for(int i =0; i< count_chatview-1; i++) {
              Navigator.pop(context);
            }
            count_chatview=0;
          }
          get_cntchat();
          get_data();
        }
      }
      }
 // print("noticevalue : $value");
  });

}

  _changeappbar(){

    double scrollposition = change_appbar.position.pixels;

    if(scrollposition > MediaQuery.of(context).size.height*0.5){
      setState(() {
        flg_floatbt=1;
      });
    }
    else{
      setState(() {
        flg_floatbt=0;
      });
    }

    if (scrollposition > 100) {
      setState(() {
          if(appbar != scroll_appbar)
           appbar = scroll_appbar;

           if(list_height == MediaQuery.of(context).size.height-(MediaQuery.of(context).size.height*0.049)) {
             start_height =0;
             list_height = list_height - (MediaQuery.of(context).size.height*0.08);
           }
      });
    }
    else {
      setState(() {
        if(appbar == scroll_appbar) {
          appbar = intro_appbar;
          start_height =0;
          list_height = list_height + MediaQuery.of(context).size.height*0.08;
        }
      //실값이 반올림되어져 비교되어짐 그래서 값이 다르게 나옴
//         if(list_height  == MediaQuery.of(context).size.height-(MediaQuery.of(context).size.height*0.05).floor()- (MediaQuery.of(context).size.height*0.08).floor()) {
//           start_height =0;
//           list_height = list_height + (MediaQuery.of(context).size.height*0.08).floor();
//         }
      });
    }

    /*if (scrollposition > 100) {

      setState(() {

        if(appbar != scroll_appbar)
          appbar = scroll_appbar;
        if(list_height == MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.049) {
          start_height =0;
          list_height = list_height - MediaQuery.of(context).size.height*0.08;
        }

      });

    }
    else {

      setState(() {

        if(appbar == scroll_appbar) {
          appbar = intro_appbar;
          start_height =0;
          list_height = list_height + MediaQuery.of(context).size.height*0.08;
        }

      });

    }*/

  }

  Widget float_button(){
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width*0.15,),
      child: InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width*0.1,
          height: MediaQuery.of(context).size.width*0.1,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child:Icon(Icons.arrow_upward,color: Colors.black,),
          ),
        ),
        onTap: (){
          change_appbar.jumpTo(change_appbar.position.minScrollExtent);
        },
      ),
    );
  }

  Future<dynamic> update_settoken(token) async{

    if(mb_id != null && mb_id !='') {

      final response = await http.post(
          Uri.encodeFull('http://14.48.175.177/update_token.php'),
          body: {
            "mb_id": mb_id,
            "token": token,
          },
          headers: {'Accept': 'applicatio n/json'}
      );
      if (response.statusCode == 200) {

      }
    }
  }

  void show_Alert(text,flg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(MediaQuery
                  .of(context)
                  .size
                  .width * 0.02))
          ),
          title:null,
          content: Container(
            child: Wrap(
                children: [
                  Text(text),
                ]),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: (){
                if(flg ==2)
                  Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showcontent() {

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.2,
            child: Column(
              children: <Widget>[
                InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.1,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
                    child: Row(
                      children: <Widget>[
                        Image.asset("images/write_icon01.png"),
                        SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                        Text("중고거래 글쓰기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)
                      ],
                    ),
                  ),
                  onTap: ()async{
                    var result = await Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>  write_normal()
                    ));
                    if(result == 'success'){
                     // print(result);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("글 등록이 완료 되었습니다."),));
                      get_data();
                    }
                    Navigator.pop(bc);
                  },
                ),
                InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.1,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
                    child: Row(
                      children: <Widget>[
                        Image.asset("images/write_icon02.png"),
                        SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                        Text("광고업체 글쓰기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)
                      ],
                    ),
                  ),
                  onTap: ()async{

                    var result = await   Navigator.push(context,MaterialPageRoute(
                        builder:(context) => chk_writead()
                    ));
                    if(result == 'success'){
                       //print(result);
                      Navigator.pop(bc);
                      show_Alert("승인을 기다려주세요!\n승인시 자동 업로드 됩니다.",1);
                      //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("승인을 기다려주세요!"),));
                      get_data();
                    }
                    else{
                      get_data();
                      Navigator.pop(bc);

                    }
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Widget get_content(id){

    var temp_data = main_item.fromJson(itemdata['data'][id]);

    String temp_price;
    String temp_wrcontent="";

    if(temp_data.ca_name =='업체'){
      temp_price=temp_data.wr_subject;
    }
    else if(temp_data.wr_1 =='무료나눔'){
      temp_price=temp_data.wr_1;
    }
    else{
      if(temp_data.wr_1.contains(','))
        temp_price = temp_data.wr_1+"원";
      else {

        MoneyFormatterOutput fmf = FlutterMoneyFormatter(
            amount: double.parse(temp_data.wr_1)).output;
        temp_price = fmf.withoutFractionDigits.toString() + '원';
      }
    }

    if(temp_data.ca_name=='업체'){
      temp_wrcontent = temp_data.wr_content.replaceAll('\n','              ');
      if(temp_wrcontent.length<15){

      }
      else{
        temp_wrcontent = temp_wrcontent.substring(0,12)+"···";
      }
    }

    InkWell temp = InkWell(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Color(0xffdddddd), width: 1)
            )
        ),
        padding: EdgeInsets.only(left: 10,right: 20,top:10,bottom: 10),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Hero(
                      tag: "hero"+id.toString(),
                      child: temp_data.wr_9!='거래완료'?
                      Container(
                        width: MediaQuery.of(context).size.width*0.225,
                        height: MediaQuery.of(context).size.width*0.2,
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
                        decoration: BoxDecoration(
                            border:  temp_data.ca_name=='업체'? Border.all(width: 2,color: Colors.forestmk):null,
                            borderRadius: BorderRadius.all(Radius.circular( MediaQuery.of(context).size.width*0.015)),
                            image: DecorationImage(//이미지 꾸미기
                                fit:BoxFit.cover,
                                image:temp_data.file[0]=='nullimage'? AssetImage("images/noimg.jpg"): NetworkImage(temp_data.file[0])//이미지 가져오기
                            )
                        ),
                      ):Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width*0.225,
                              height: MediaQuery.of(context).size.height*0.2,
                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
                              decoration: BoxDecoration(
                                  border:  temp_data.ca_name=='업체'? Border.all(width: 2,color: Colors.forestmk):null,
                                  borderRadius: BorderRadius.all(Radius.circular( MediaQuery.of(context).size.width*0.02)),
                                  image: DecorationImage(//이미지 꾸미기
                                      fit:BoxFit.cover,
                                      image:temp_data.file[0]=='nullimage'? AssetImage("images/noimg.jpg"): NetworkImage(temp_data.file[0])//이미지 가져오기
                                  )
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.225,
                              height: MediaQuery.of(context).size.height*0.2,
                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8)
                              ),
                              child: Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.225,
                                  height: MediaQuery.of(context).size.height*0.04,
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                  ),
                                  child: Center(child: Text("판매완료", style: TextStyle(color: Color(0xff000000),fontSize: MediaQuery.of(context).size.width*0.035, decoration: TextDecoration.none, fontWeight: FontWeight.normal))),
                                ),
                              ),
                            )
                          ]
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: temp_data.ca_name!='업체'? MainAxisAlignment.center: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: MediaQuery.of(context).size.height*0.003,),
                        Text(temp_data.wr_subject.length<15?temp_data.wr_subject:temp_data.wr_subject.substring(0,12)+"···", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035, fontWeight: temp_data.ca_name=='업체'?FontWeight.bold:null),),
                        SizedBox(height: temp_data.ca_name=='업체'?MediaQuery.of(context).size.height*0.003:MediaQuery.of(context).size.height*0.003,),
                        Text(temp_data.ca_name=='업체'?temp_wrcontent:temp_price, style: TextStyle(fontSize: temp_data.ca_name=='업체'?MediaQuery.of(context).size.width*0.028:MediaQuery.of(context).size.width*0.035, fontWeight:temp_data.ca_name=='업체'?null:FontWeight.bold)),
//                        temp_data.ca_name!='업체'? SizedBox(height: MediaQuery.of(context).size.height*0.005,): Container(),
                        SizedBox(height: MediaQuery.of(context).size.height*0.003,),
                        Row(
                          children: <Widget>[
                            Text(temp_data.ca_name=='업체'?temp_data.wr_11:temp_data.mb_2,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025, color:Color(0xff444444))),
//                            Text(temp_data.mb_2,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025, color:Color(0xff444444))),
                            SizedBox(width: MediaQuery.of(context).size.width*0.005,),
                            Container(
                              width: MediaQuery.of(context).size.width*0.01,
                              height: MediaQuery.of(context).size.width*0.01,
                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.005,right: MediaQuery.of(context).size.width*0.005,),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.05,)),
                                  color: Colors.forestmk
                              ),
                            ),
                            Text(temp_data.timegap,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)),

                          ],

                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.0075,),
                        Row(
                          children: <Widget>[
                            Text( temp_data.ca_name!='업체'? temp_data.ca_name:'광고업체', style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)),
                            Image.asset("images/fa-angle-right.png", height: MediaQuery.of(context).size.height*0.018,),
                            Container(
                              width: MediaQuery.of(context).size.width*0.01,
                              height: MediaQuery.of(context).size.width*0.01,
                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.005,right: MediaQuery.of(context).size.width*0.005,),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.05,)),
                                  color: Colors.forestmk
                              ),
                            ),
                            Image.asset("images/fa-heart.png",height: MediaQuery.of(context).size.height*0.018,),
                            Text(temp_data.like, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.026,)),
                            Container(
                              width: MediaQuery.of(context).size.width*0.01,
                              height: MediaQuery.of(context).size.width*0.01,
                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.005,right: MediaQuery.of(context).size.width*0.005,),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.05,)),
                                  color: Colors.forestmk
                              ),
                            ),
                            Image.asset("images/fa-comment.png",height: MediaQuery.of(context).size.height*0.018,),
                            Text(temp_data.comments, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.026)),
                          ],
                        ),
                      ],
                    ),]
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        //border: Border.all(color: Color(0xffcccccc)),
                        color: Color(0xfff3f3f3),
                        image: DecorationImage(//이미지 꾸미기
                            fit:BoxFit.cover,
                            image:temp_data.profile_img!=''? NetworkImage(temp_data.profile_img): AssetImage("images/wing_mb_noimg2.png")//이미지 가져오기
                        )
                    ),
                  ),
                  SizedBox(height: 6,),
                  Text(temp_data.mb_name.length<5?temp_data.mb_name:temp_data.mb_name.substring(0,3)+"···",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03),)
                ],
              ),
            ],
          )
          ,
        ),
      ),

      onTap: ()async{
        var result = await Navigator.push(context, PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => Viewpage(tag:"hero"+id.toString(), src:temp_data.file[0],info: temp_data,mb_id :mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,),
        ));
        if(result == 'delete'){
          get_data();
        }
        /*   Navigator.push(context,MaterialPageRoute(

              builder:(context) => Viewpage(tag:"hero"+id.toString(), src:temp_data.file[0],info: temp_data,)
          ));*/
      },
    );
    return temp;
  }

  void show_quit(){

    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context2).size.width*0.03))
            ),
            content: Container(
              width: MediaQuery.of(context2).size.width,
              height: MediaQuery.of(context2).size.height*0.42,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context2).size.width,
                    height: MediaQuery.of(context2).size.height*0.25,
                    decoration: BoxDecoration(
                        image: DecorationImage(//이미지 꾸미기
                          fit:BoxFit.cover,
                          //image:  AssetImage("images/wing_mb_noimg2.png"),
                          image:AssetImage("images/NISI20190410_0000306205_web.jpg")
                        )
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context2).size.width,
                    height: MediaQuery.of(context2).size.height*0.075,
                    child: Center(child: Text("서비스를 종료 하시겠습니까?",style: TextStyle(fontSize: MediaQuery.of(context2).size.width*0.04),)),
                  ),
                  Container(
                    width: MediaQuery.of(context2).size.width,
                    height: MediaQuery.of(context2).size.height*0.075,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context2).size.width*0.3,
                            height: MediaQuery.of(context2).size.height*0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              border: Border.all(color: Colors.forestmk,width: 1)
                            ),
                            child: Center(child: Text("아니오")),
                          ),
                          onTap: (){
                            Navigator.pop(context2);
                          },
                        ),
                        SizedBox(width: MediaQuery.of(context2).size.width*0.02,),
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context2).size.width*0.3,
                            height: MediaQuery.of(context2).size.height*0.06,
                            decoration: BoxDecoration(
                              color: Colors.forestmk,
                              borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                            child: Center(child: Text("예")),
                          ),
                          onTap: (){
                            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                        },
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
            actions:null
        );
      },
    );
  }

  void request_logindialog(){

      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.03))

              ),
              content: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.03,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("로그인이 필요합니다.", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),)
                  ],
                ),
              ),
              actions:  <Widget>[
                new FlatButton(
                  child: new Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(
                        builder:(context) => loginpage()
                    ));
                  },
                ),
              ]
          );
        },
      );
  }

  void _searchdialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03, right: MediaQuery.of(context).size.width*0.03, top: MediaQuery.of(context).size.height*0.02,bottom: MediaQuery.of(context).size.height*0.005),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.03))
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Wrap(
              children: [Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.05,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1, color: Color(0xffefefef)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("최근순"),
                          Radio(
                            value: "최근순",
                            groupValue: sort_value,
                            onChanged: (T){
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                                sort_value = T;
                                get_data();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        sort_value = '최근순';
                        get_data();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  mb_id !=null && mb_id !=''?
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.07,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1, color: Color(0xffefefef)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("거리순"),
                          Radio(
                            value: "거리순",
                            groupValue: sort_value,
                            onChanged: (T){
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                                sort_value = T;
                                get_data();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        sort_value = '거리순';
                        get_data();
                      });
                      Navigator.pop(context);
                    },
                  ):Container(),
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.07,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1, color: Color(0xffefefef)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("낮은가격순"),
                          Radio(
                            value: "낮은가격순",
                            groupValue: sort_value,
                            onChanged: (T){
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                                sort_value = T;
                                get_data();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        sort_value = '낮은가격순';
                        get_data();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.07,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1, color: Color(0xffefefef)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("높은가격순"),
                          Radio(
                            value: "높은가격순",
                            groupValue: sort_value,
                            onChanged: (T){
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                                sort_value = T;
                                get_data();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        sort_value = '높은가격순';
                        get_data();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.07,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("조회수순"),
                          Radio(
                            value: "조회수순",
                            groupValue: sort_value,
                            onChanged: (T){
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                                sort_value = T;
                                get_data();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        sort_value = '조회수순';
                        get_data();
                      });
                      Navigator.pop(context);
                    },
                  ),

                ],
              ),
            ]
            ),
          ),
          actions: null
        );
      },
    );
  }

  Future<dynamic> get_mbdata() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_mb.php'),
        body: {
          "mb_id":mb_id==null?'':mb_id,
        },
        headers: {'Accept' : 'application/json'}
    );
      //print(jsonDecode(response.body));

      var temp_mbdata = jsonDecode(response.body);

      setState(() {
        mb_hp = temp_mbdata['mb_hp'];
        mb_name = temp_mbdata['mb_name'];
        if(temp_mbdata['mb_1']!='') {
          mb_1 = "http://14.48.175.177/data/member/" + temp_mbdata['mb_1'];
        }
        else{
          mb_1='test';
        }

        mb_2 = temp_mbdata['mb_2'];
        mb_3 = temp_mbdata['mb_3'];
        mb_4 = temp_mbdata['mb_4'];
        mb_5 = temp_mbdata['mb_5'];
        mb_6 = temp_mbdata['mb_6'];
      });
  }

  Future<dynamic> get_cntchat() async{
     // print("test_getdata"+mb_id);

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_countmsg.php'),
        body: {
          "mb_id":mb_id==null?'':mb_id,
        },
        headers: {'Accept' : 'application/json'}
    );

    if(response.statusCode==200){
      setState(() {
        print("launch_cntchat");
        count_msg = response.body.toString();
      });
    }

  }

 Future<dynamic> get_data() async{
  //  print("test_getdata"+mb_id);
   final response = await http.post(
       Uri.encodeFull('http://14.48.175.177/get_write.php'),
       body: {
         "mb_id":mb_id==null?'':mb_id,
         "sch_order":sort_value,
         "nowlat":mb_5,
         "nowlng":mb_6,
         "sch_text" : search_text.text,
         "sch_flghide":checkbox_adv==true?'1':'',
         "sch_flgsold":checkbox_soldout==true?'1':'',
       },
       headers: {'Accept' : 'application/json'}
   );

    setState(() {
      //print(response.body);
     itemdata = jsonDecode(response.body);
     _getWidget();
     if(mb_id!=null) {
       get_cntchat();
     }
   });

  }

  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
      if(sp.getString('id')!=null) {
        mb_id = sp.getString('id');
        mb_pwd = sp.getString('pwd');
        if(mb_id !=null && mb_id !='') {
          get_mbdata();
        }
      }
      get_data();
  }

  Future<void> showNotification(title,body,link) async {

    var android = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription');
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await FlutterLocalNotificationsPlugin().show(0, title, body, platform,payload: link);

  }


  Future handelDynamicLinks() async{

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeeplink(data);

    FirebaseDynamicLinks.instance.onLink(

        onSuccess: (PendingDynamicLinkData dynamicLinkdata) async{
          _handleDeeplink(dynamicLinkdata);
        },
        onError: (OnLinkErrorException e) async{
          print("Dynamic Link Failed: ${e.message}");
        }
    );
  }

  void _handleDeeplink(PendingDynamicLinkData data){
    final Uri deepLink = data?.link;
    if(deepLink !=null){
      print('test | $deepLink');
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    handelDynamicLinks();
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  @override
  Future <void> initState() {
    // TODO: implement initState
    super.initState();
//    Future.delayed(Duration(milliseconds: -1), () {
//      Navigator.push(context,
//          MaterialPageRoute(builder: (context) => splash()));
//    });

    initlocalnotice();
    appbar = intro_appbar;
    change_appbar.addListener(_changeappbar);

    load_myinfo();

    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.configure(

      onMessage: (Map<String, dynamic> message) async {
        //print("onMessage: "+message.toString());
        if(Platform.isIOS){
         /* showNotification(
              message['aps']['alert']['title'].toString(),
              message['aps']['alert']['body'].toString(),
              message['aps']['alert']['flutter_go'].toString(),
             );*/
        }
        else {

          if(message['data']['flutter_go'].toString()=='댓글'){
            showNotification(message['notification']['title'].toString(),
                message['notification']['body'].toString(),'댓글');
          }

          else {
            showNotification(message['notification']['title'].toString(),
                message['notification']['body'].toString(),
                message['data']['flutter_go'].toString());
          }

        }
        get_cntchat();
      },
      //onBackgroundMessage:Platform.isIOS?null:myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        /*  setState(() {
            flg_pushchat = true;
          });*/
          count_chatview ++;
       /*  var result = await Navigator.push(context, MaterialPageRoute(
              builder: (context) => chat_webview(url:"http://14.48.175.177/bbs/login_check.php?mb_id="+mb_id+"&mb_password="+mb_pwd+"&flg_flutter=1")
          ));
   //       print("onLaunch - "+result);
          if(result == 'change'){
            if(count_chatview>1){
              for(int i=0; i<count_chatview-1; i++) {
                Navigator.pop(context);
              }
              count_chatview =0;
            }
            get_cntchat();
            get_data();
          }*/
          var result = await Navigator.push(
              context, MaterialPageRoute(
              builder: (context) =>
                  chat_webview(
                    url: Platform.isIOS?
                    "http://14.48.175.177/bbs/login_check.php?mb_id=" +
                        mb_id + "&mb_password=" +
                        mb_pwd+ "&flg_view=1&view_id="+message['flutter_go']:
                    "http://14.48.175.177/bbs/login_check.php?mb_id=" +
                        mb_id + "&mb_password=" +
                        mb_pwd+ "&flg_view=1&view_id="+message['data']['flutter_go'],
                    view: 1,mb_id: mb_id,room_id: message['data']['flutter_go']
                  )
          ));
          if (result == 'change') {
            if(count_chatview>1){
              for(int i=0; i<count_chatview-1; i++) {
                Navigator.pop(context);
              }
              count_chatview =0;
            }
            get_cntchat();
            get_data();
          }
        //print("onLaunch: "+message.toString());
      },
      onResume: (Map<String, dynamic> message) async {

        count_chatview ++;
        var result = await Navigator.push(
            context, MaterialPageRoute(
            builder: (context) =>
                chat_webview(
                  url: Platform.isIOS?
                  "http://14.48.175.177/bbs/login_check.php?mb_id=" +
                      mb_id + "&mb_password=" +
                      mb_pwd+ "&flg_view=1&view_id="+message['flutter_go']:

                  "http://14.48.175.177/bbs/login_check.php?mb_id=" +
                      mb_id + "&mb_password=" +
                      mb_pwd+ "&flg_view=1&view_id="+message['data']['flutter_go']
                  ,view: 1,mb_id: mb_id,room_id: Platform.isIOS?message['flutter_go']:message['data']['flutter_go']
                )
        ));
        if (result == 'change') {
          if(count_chatview>1){
            for(int i=0; i<count_chatview-1; i++) {
              Navigator.pop(context);
            }
            count_chatview =0;
          }
          get_cntchat();
          get_data();
        }
      /*  var result = await Navigator.push(context, MaterialPageRoute(
            builder: (context) => chat_webview(url:"http://14.48.175.177/bbs/login_check.php?mb_id="+mb_id+"&mb_password="+mb_pwd+"&flg_flutter=1")
        ));
        if(result == 'change'){
          if(count_chatview>1){
            for(int i=0; i<count_chatview-1; i++) {
              Navigator.pop(context);
            }
            count_chatview =0;
          }
          get_cntchat();
          get_data();
        }*/
       // print("onResume: "+message.toString());
      },
    );
    _firebaseMessaging.getToken().then((token) {
      update_settoken(token);
    });
  //  get_data();
  }

  @override
  Widget build(BuildContext context) {
    print("build!!");
    print(count_chatview);
    if(mb_name !=null){
      if(mb_name.length>10){
        mb_name = mb_name.substring(0,10)+"···";
      }
    }

    if(mb_id !=null) {
      mb_infowidget  = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height*0.013,),
          Text(mb_name,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.033, fontWeight: FontWeight.bold),),
          SizedBox(height: MediaQuery.of(context).size.height*0.0028,),
          Text(mb_2,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, color: Color(0xff666666))),
        ],
      );
    }

    if(start_height == 1){
        list_height = MediaQuery.of(context).size.height-(MediaQuery.of(context).size.height*0.049);
        scrollbar_height = MediaQuery.of(context).size.height*0.08;
        scroll_appbar = PreferredSize(
            preferredSize: Size.fromHeight(scrollbar_height),
            child: AppBar(
              title: null,
              elevation: 0.0,
              backgroundColor: Colors.white,
              actions: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.07,right: MediaQuery.of(context).size.width*0.07,top: 10,bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: 40,
                          height: scrollbar_height*0.8,
                          padding: EdgeInsets.all(3),
                          child: Image.asset("images/hd_cate01.png"),
                        ),
                        onTap: (){
                          sort_value='최근순';
                          get_data();
                        },
                      ),

                      InkWell(
                        child: Container(
                          width: 40,
                          height: scrollbar_height*0.8,
                          padding: EdgeInsets.all(3),
                          child: Image.asset("images/hd_cate02.png"),
                        ),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(
                              builder:(context) => search_main(title:'광고' ,sch_flgadv: "1", mb_id :mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                          ));
                        },
                      ),

                      InkWell(
                        child: Container(
                          width: 40,
                          height: scrollbar_height*0.8,
                          padding: EdgeInsets.all(3),

                          child: Image.asset("images/hd_cate03.png"),
                        ),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(
                              builder:(context) => categorypage(mb_id:mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                          ));

                        },
                      ),

                      InkWell(
                        child: Container(
                          width: 40,
                          height: scrollbar_height*0.8,
                          padding: EdgeInsets.all(3),

                          child: Image.asset("images/hd_cate04.png"),
                        ),
                        onTap: (){
                          if(mb_id!=null) {
                            Navigator.push(context,MaterialPageRoute(
                                builder:(context) => my_items(title: "최근 본 글",mb_id:mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                            ));
                          }
                          else{
                            request_logindialog();
                          }
                        },
                      ),
                      InkWell(
                        child: Container(
                          width: 40,
                          height: scrollbar_height*0.8,
                          padding: EdgeInsets.all(3),
                          child: Image.asset("images/hd_cate05.png"),
                        ),
                        onTap: ()async{
                          if(mb_id!=null) {
                            var result = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => mypage(mb_id:mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                            ));
                            if(result == 'back'){
                              get_mbdata();
                              get_data();
                            }
                          }
                          else{
                            request_logindialog();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
        );
    }
    if(flg_search == false) {
      head_first = Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.075,
          decoration: new BoxDecoration(color: Colors.white),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: MediaQuery
                      .of(context)
                      .size
                      .width * 0.05,
                      top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.016,
                      bottom: MediaQuery
                      .of(context)
                      .size
                      .height * 0.016),
                  child: Image.asset("images/logo_name.png", fit: BoxFit.fill,),
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.085,
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * 0.085,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: Color(0xffeeeeee))
                        ),
                        child: Image.asset("images/hd_icon01.png"),
                      ),
                      onTap: () {
                        setState(() {
                          if(flg_search==false)
                            flg_search = true;
                          else
                            flg_search = false;
                        });
                      },
                    ),

                    SizedBox(width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.03,),
                    InkWell(
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.09,
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * 0.09,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: Color(0xffeeeeee))
                        ),
                        child: Image.asset("images/hd_icon02.png"),
                      ),
                      onTap: () async{
                        if(mb_id!=null) {
                          var result = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => location(mb_2:mb_2, mb_id:mb_id)
                          ));
                          if(result == 'change'){
                            get_mbdata();
                            get_data();
                          }
                        }
                        else{
                          request_logindialog();
                        }
                      },
                    ),
                    SizedBox(width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.03,),
                    InkWell(
                      child: Stack(
                        overflow: Overflow.visible,
                        children: [
                          Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.09,
                          height: MediaQuery
                              .of(context)
                              .size
                              .width * 0.09,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              border: Border.all(color: Color(0xffeeeeee))
                         ),
                          child: Image.asset("images/hd_icon03.png"),
                          ),
                          int.parse(count_msg)>0?
                          Positioned(
                            top: -5,
                            right: -5,
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.05,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.05,
                              decoration: BoxDecoration(
                                  color: Color(0xffed670d),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  border: Border.all(color: Color(0xffeeeeee))
                              ),
                              child: Center(child: Text(count_msg, style: TextStyle(color: Colors.white),)),
                            ),
                          ):SizedBox(),
                        ],
                      ),
                      onTap: () async{
                        if(mb_id!=null) {
                          var result = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => chat_webview(url:"http://14.48.175.177/bbs/login_check.php?mb_id="+mb_id+"&mb_password="+mb_pwd+"&flg_flutter=1", mb_id: mb_id,)
                          ));
                        //  print(result+"testresult");
                   //       print(result+"testresult");
                          if(result == 'change'){
                          //  print(result+"testresult");
                            get_cntchat();
                            get_data();
                          }
                        }
                        else{
                          request_logindialog();
                        }
                      },
                    ),
                    SizedBox(width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.02,),
                  ],
                )
              ]
          )
      );
    }
    else{
      head_first = Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.075,
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04,right: MediaQuery.of(context).size.width*0.04,top:  MediaQuery.of(context).size.height * 0.001,bottom:  MediaQuery.of(context).size.height * 0.001,),
            decoration: new BoxDecoration(
                color: Colors.white
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height * 0.075,
                  child:TextFormField(
                    controller: search_text,
                    maxLines: 1,
                    maxLength: null,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xfff9f9f9),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Color(0xffefefef))
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Color(0xffefefef))
                        ),
                        suffixIcon:
                        InkWell(
                            child: Icon(Icons.search),
                            onTap: (){
                             // Navigator.pop(context);
                              FocusScope.of(context).requestFocus(FocusNode());
                              get_data();
                              //search_text.text='';
                            },
                        ),
                        hintText: "원하시는 키워드를 입력하세요",
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                InkWell(
                    child:
                    Icon(
                      Icons.clear,
                      color: Colors.forestmk,
                      size: MediaQuery.of(context).size.width*0.08,),
                    onTap: (){
                      setState(() {
                        if(flg_search==false)
                          flg_search = true;
                        else {
                          search_text.text= "";
                          flg_search = false;
                          get_data();
                        }
                      });
                    },
                ),
              ],
            )
      );
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key:_scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: appbar,
//      decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(Radius.circular(50)),
//          border: Border.all(color: Color(0xffcccccc))
//      ),
        body: WillPopScope(
         onWillPop: (){
            show_quit();
         },
        child:
//        Column(
//        children: <Widget>[
//          Container(
//            height: list_height,
//            decoration: BoxDecoration(color: Colors.white),
//            child:
              ListView(
              controller: change_appbar,
              children: <Widget>[
                SizedBox(height: 5,),
                head_first,
                Container(
                    padding: EdgeInsets.only(left: 22, right: 22),
                    height: MediaQuery.of(context).size.height*0.075,
                    decoration: new BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),
                            child: Image.asset("images/hd_cate01.png"),
                          ),
                          onTap: (){
                            sort_value='최근순';
                            get_data();
                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.asset("images/hd_cate02.png"),
                          ),
                          onTap: (){
                            //print(mb_3);
                            Navigator.push(context,MaterialPageRoute(
                                builder:(context) => search_main(title:'광고' ,sch_flgadv: "1", mb_id :mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                            ));
                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.asset("images/hd_cate03.png"),
                          ),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(
                                builder:(context) => categorypage(mb_id:mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                            ));
                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.asset("images/hd_cate04.png"),
                          ),
                          onTap: (){
                            if(mb_id!=null) {
                              Navigator.push(context,MaterialPageRoute(
                                  builder:(context) => my_items(title: "최근 본 글",mb_id:mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                              ));
                            }
                            else{
                              request_logindialog();
                            }
                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.asset("images/hd_cate05.png"),
                          ),
                          onTap: () async{
                            if(mb_id!=null) {
                              var result = await Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => mypage(mb_id:mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                              ));
                              if(result == 'back'){
                                get_mbdata();
                                get_data();
                              }
                            }
                            else{
                              request_logindialog();
                            }
                          },
                        ),


                      ],
                    )),
                Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    decoration: BoxDecoration(color: Colors.white),
                    padding:EdgeInsets.only(left: 22,right: 22),
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.12,
                                height: MediaQuery.of(context).size.width*0.12,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Color(0xfff3f3f3),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
//                                    border: Border.all(color: Color(0xffcccccc)),
                                    image: DecorationImage(//이미지 꾸미기
                                        fit:BoxFit.cover,
                                        //image:  AssetImage("images/wing_mb_noimg2.png"),
                                        image:mb_1=='test'?
                                        AssetImage("images/wing_mb_noimg2.png"):
                                        NetworkImage(mb_1),
                                    )
                                ),
                              ),
                              onTap: (){

                              },
                            ),
                            SizedBox(width: 10,),
                            InkWell(
                              child:
                              Container(
                                  height: MediaQuery.of(context).size.height*0.08,
                                  child: Center(child: mb_infowidget)
                              ),
                              onTap: () async{
                                if(mb_id==null) {
                                      Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => loginpage()
                                  ));
                                  /*if(result!=null){
                                    setState(() {

                                    });
                                  }*/
                                }
                                else{
                                  var result = await Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => mypage(mb_id:mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                                  ));
                                  if(result == 'back'){
                                    get_mbdata();
                                    get_data();
                                  }
                                /*  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => mypage(mb_id:mb_id,mb_pwd:mb_pwd,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                                  ));*/
                                }
                              },
                            ),
                          ],
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.25,
                            height: MediaQuery.of(context).size.height*0.035,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Color(0xff444444),
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                border: Border.all(color: Color(0xffcccccc))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(3),
                                  child:Image.asset("images/mb_write_btn.png"),
                                ),
                                Text("글쓰기",style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                          onTap: (){
                            if(mb_id!=null) {
                              _showcontent();
                            }
                            else{
                              request_logindialog();
                            }
                          },
                        ),
                      ],
                    )
                ),
                Container(
                    padding: EdgeInsets.only(left: 22, right: 22),
                    height: MediaQuery.of(context).size.height*0.06,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xffdddddd), width: 1),
                          bottom: BorderSide(color: Color(0xffdddddd), width: 1),
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Text(sort_value,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.032),),
                              Image.asset("images/arrow_filter.png"),
                            ],
                          ),
                          onTap: (){
                            _searchdialog();
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color:Color(0xffeeeeee),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: Color(0xffeeeeee),),
                                child: Checkbox(
                                  value: checkbox_soldout,
                                  activeColor: Color(0xffeeeeee),
                                  checkColor: Colors.black,
                                  onChanged :(bool value){
                                    setState(() {
                                      checkbox_soldout = value;
                                      get_data();
                                    });
                                }
                                ),
                              ),
                            ),
                            Text("거래완료",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03),),
                            SizedBox(width: MediaQuery.of(context).size.width*0.016,),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color:Color(0xffeeeeee),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: Theme(
                                data: ThemeData(unselectedWidgetColor: Color(0xffeeeeee),),
                                child: Checkbox(
                                  value: checkbox_adv,
                                  activeColor: Color(0xffeeeeee),
                                  checkColor: Colors.black,
                                  onChanged: (bool value){
                                    setState(() {
                                      checkbox_adv = value;
                                      get_data();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Text("업체안보기", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03)),
                          ],
                        ),
                      ],
                    )
                ),
               Column(
                 children: items_content
               )
              ],
            ),
          ),
//          Container(
//            height: MediaQuery.of(context).size.height*0.1,
//            decoration: BoxDecoration(
//                image: DecorationImage(//이미지 꾸미기
//                    fit:BoxFit.cover,
//                    image:AssetImage("images/ft_bn.jpg")//이미지 가져오기
//                )
//            ),
//          ),
// 리스트뷰만으로 변경하면서 주석 처리된부분 광고 살릴시 아래부분 살려야함
//        ],
//          ),
//        ),
    floatingActionButton: flg_floatbt==1?float_button():Container()
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  _getWidget(){
    if(itemdata.length<0){
      setState(() {
        items_content.add(Container());
      });
    }
    else {
      setState((){
        items_content.clear();
        for (var i = 0; i < itemdata['data'].length; i++) {
          items_content.add(get_content(i));
        }
      });
    }
  }
}
