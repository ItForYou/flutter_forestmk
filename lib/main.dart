

import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterforestmk/categorypage.dart';
import 'package:flutterforestmk/chk_writead.dart';
import 'package:flutterforestmk/location.dart';
import 'package:flutterforestmk/loginpage.dart';
import 'package:flutterforestmk/main_item.dart';
import 'package:flutterforestmk/my_items.dart';
import 'package:flutterforestmk/register.dart';
import 'package:flutterforestmk/search_main.dart';
import 'package:flutterforestmk/write_normal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterforestmk/viewpage.dart';
import 'package:flutterforestmk/mypage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.

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

        primarySwatch: Colors.forestmk
      ),
      home: MyHomePage(title: '숲마켓', ),
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool checkbox_soldout = false;
  bool checkbox_adv = false;
  ScrollController change_appbar = ScrollController();
  TextEditingController search_text = new TextEditingController();
  main_item item;
  int start_height=1;
   double list_height;
  static double scrollbar_height=1;
  PreferredSize appbar;
  Widget head_first, mb_infowidget=Text("로그인 후, 이용해주세요",style: TextStyle(color: Colors.black));
  bool flg_search = false;
  String sort_value = "최근순", mb_id,mb_pwd,mb_2="test",mb_1="test",mb_name="test",mb_hp,mb_3,mb_4,mb_5,mb_6;
  var itemdata;
  List <Widget> items_content=[];
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
  void soldout_changed(bool value) => setState(() => checkbox_soldout = value);
  void adv_changed(bool value) => setState(() => checkbox_adv = value);


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  _changeappbar() {

    double scrollposition = change_appbar.position.pixels;

    if (scrollposition > 100) {
      setState(() {
          if(appbar != scroll_appbar)
           appbar = scroll_appbar;
           if(list_height == MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.15) {
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
      //실값이 반올림되어져 비교되어짐 그래서 값이 다르게 나옴
         /*if(list_height  == MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.23) {

         }*/
      });
    }
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
                  onTap: (){

                    Navigator.push(context,MaterialPageRoute(
                        builder:(context) => write_normal()
                    ));
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
                        Text("광고문의 글쓰기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(
                        builder:(context) => chk_writead()
                    ));
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
    //print(temp_data.file[0]);
    if(temp_data.wr_1!='무료나눔' && temp_data.ca_name !='업체'){

    }
      InkWell temp = InkWell(
        child: Container(
          height: 110,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xfff7f7f7), width: 2)
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
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.27,
                    height: MediaQuery.of(context).size.height*0.2,

                    decoration: BoxDecoration(
                      border:  temp_data.ca_name=='업체'? Border.all(width: 2,color: Colors.forestmk):null,
                      borderRadius: BorderRadius.all(Radius.circular( MediaQuery.of(context).size.width*0.02)),
                      image: DecorationImage(//이미지 꾸미기
                            fit:BoxFit.fitWidth,
                            image:temp_data.file[0]=='nullimage'? AssetImage("images/noimg.jpg"): NetworkImage(temp_data.file[0])//이미지 가져오기
                        )
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Column(

                  mainAxisAlignment: temp_data.ca_name!='업체'? MainAxisAlignment.start: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5,),
                    Text(temp_data.wr_subject, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),),
                    SizedBox(height: 5,),
                    temp_data.ca_name!='업체'? Text(temp_data.wr_1, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),): Container(),
                    temp_data.ca_name!='업체'? SizedBox(height: 8,): Container(),
                    Row(
                      children: <Widget>[
                        Text(temp_data.mb_2,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)),
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
                    SizedBox(height: MediaQuery.of(context).size.height*0.006,),
                    Row(
                      children: <Widget>[
                        temp_data.ca_name!='업체'? Text(temp_data.ca_name, style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)):Container(),
                        temp_data.ca_name!='업체'? Image.asset("images/fa-angle-right.png", height: MediaQuery.of(context).size.height*0.018,):Container(),
                        temp_data.ca_name!='업체'?Container(
                          width: MediaQuery.of(context).size.width*0.01,
                          height: MediaQuery.of(context).size.width*0.01,
                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.005,right: MediaQuery.of(context).size.width*0.005,),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.05,)),
                              color: Colors.forestmk
                          ),
                        ):Container(),
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
                        Text("0", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.026)),
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
                    Text(temp_data.mb_name,style: TextStyle(fontSize: 12),)
                  ],
                ),
              ],
            )
            ,
          ),
        ),

        onTap: (){
          Navigator.push(context,MaterialPageRoute(
              builder:(context) => Viewpage(tag:"hero"+id.toString(), src:temp_data.file[0],info: temp_data,)
          ));
        },
      );


      return temp;
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
  void _searchdialog() {
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
            height: MediaQuery.of(context).size.height*0.26,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
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
                            sort_value = T;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.07,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: Color(0xffefefef)))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("조회수순"),
                      Radio(
                        value: "조회수순",
                        groupValue: sort_value,
                        onChanged: (T){
                          setState(() {
                            sort_value = T;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
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
                            sort_value = T;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("거리순"),
                      Radio(
                        value: "거리순",
                        groupValue: sort_value,
                        onChanged: (T){
                          setState(() {
                            sort_value = T;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          actions: null
        );
      },
    );
  }

 Future<dynamic> get_data() async{
   final response = await http.post(
       Uri.encodeFull('http://14.48.175.177/get_write.php'),
       body: {
       },
       headers: {'Accept' : 'application/json'}
   );
   setState(() {
     itemdata = jsonDecode(response.body);
     _getWidget();
   });
  }

  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      if(sp.getString('id')!=null) {
        mb_id = sp.getString('id');
        mb_pwd = sp.getString('pwd');
        mb_name = sp.getString('mb_name');
        mb_hp = sp.getString('mb_hp');
        mb_1 = sp.getString('mb_1');
        mb_2 = sp.getString('mb_2');
        mb_3 = sp.getString('mb_3');
        mb_4 = sp.getString('mb_4');
        mb_5 = sp.getString('mb_5');
        mb_6 = sp.getString('mb_6');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    appbar = intro_appbar;
    change_appbar.addListener(_changeappbar);
    get_data();
    //print(itemdata['data'][0]);
    super.initState();
    load_myinfo();
  }

  @override
  Widget build(BuildContext context) {
    if(mb_id !=null) {
      mb_infowidget  = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height*0.015,),
          Text(mb_name,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05),),
          Text(mb_2,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03)),
        ],
      );
    }
    if(start_height == 1){
        list_height = MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.15;
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
                              builder:(context) => search_main(sch_flgadv: "1", mb_id:mb_id,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
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
                              builder:(context) => categorypage()
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
                                builder:(context) => my_items(title: "최근 본 글",mb_id:mb_id,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
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
                        onTap: (){
                          if(mb_id!=null) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => mypage(mb_id:mb_id,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                            ));
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
                  padding: EdgeInsets.only(left: MediaQuery
                      .of(context)
                      .size
                      .width * 0.05, top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.01, bottom: MediaQuery
                      .of(context)
                      .size
                      .height * 0.01),
                  child: Image.asset("images/logo_name.png", fit: BoxFit.fill,),
                ),
                Row(
                  children: <Widget>[
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
                            border: Border.all(color: Color(0xffcccccc))
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
                        .width * 0.02,),
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
                            border: Border.all(color: Color(0xffcccccc))
                        ),
                        child: Image.asset("images/hd_icon02.png"),
                      ),
                      onTap: () {
                        if(mb_id!=null) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => location(mb_2:mb_2)
                          ));
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
                            border: Border.all(color: Color(0xffcccccc))
                        ),
                        child: Image.asset("images/hd_icon03.png"),
                      ),
                      onTap: () {
                        if(mb_id!=null) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => location()
                          ));
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
                              print(search_text.text);
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
                        else
                          flg_search = false;
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
      resizeToAvoidBottomPadding: false,
      appBar: appbar,
//      decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(Radius.circular(50)),
//          border: Border.all(color: Color(0xffcccccc))
//      ),
        body:Column(
        children: <Widget>[
          Container(
            height: list_height,
            decoration: BoxDecoration(color: Colors.white),
            child: ListView(
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
                                builder:(context) => search_main(sch_flgadv: "1", mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
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
                                builder:(context) => categorypage()
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
                                  builder:(context) => my_items(title: "최근 본 글",mb_id:mb_id,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
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
                          onTap: (){
                            if(mb_id!=null) {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>  mypage(mb_id:mb_id,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                              ));
                            }
                            else{
                              request_logindialog();
                            }
                          },
                        ),


                      ],
                    )),
                Container(
                    height: MediaQuery.of(context).size.height*0.08,
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
                                width: MediaQuery.of(context).size.width*0.15,
                                height: MediaQuery.of(context).size.width*0.15,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Color(0xfff3f3f3),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(color: Color(0xffcccccc)),
                                    image: DecorationImage(//이미지 꾸미기
                                        fit:BoxFit.cover,
                                        //image:  AssetImage("images/wing_mb_noimg2.png"),
                                        image:mb_1=='test'?
                                        AssetImage("images/wing_mb_noimg2.png"):
                                        NetworkImage( mb_1,),
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
                              onTap: () {
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
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => mypage(mb_id:mb_id,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
                                  ));
                                }
                              },
                            ),
                          ],
                        ),
                        InkWell(
                          child: Container(
                            width: 100,
                            height: 30,
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
                          top: BorderSide(color: Color(0xfff7f7f7), width: 2),
                          bottom: BorderSide(color: Color(0xfff7f7f7), width: 2),
                        )

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Text(sort_value),
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
                              child: Checkbox(
                                value: checkbox_soldout,
                                activeColor: Colors.black12,
                                onChanged: soldout_changed,
                              ),
                            ),
                            Text("거래완료"),
                            Container(
                              width: 20,
                              child: Checkbox(
                                value: checkbox_adv,
                                activeColor: Colors.black12,
                                onChanged: adv_changed,
                              ),
                            ),
                            Text("업체안보기"),
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
          Container(
            height: MediaQuery.of(context).size.height*0.1,
            decoration: BoxDecoration(
                image: DecorationImage(//이미지 꾸미기
                    fit:BoxFit.cover,
                    image:AssetImage("images/ft_bn.jpg")//이미지 가져오기
                )
            ),
          ),
        ],
      ),
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
