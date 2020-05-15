import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterforestmk/categorypage.dart';
import 'package:flutterforestmk/chk_writead.dart';
import 'package:flutterforestmk/location.dart';
import 'package:flutterforestmk/loginpage.dart';
import 'package:flutterforestmk/write_normal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterforestmk/viewpage.dart';
import 'package:flutterforestmk/mypage.dart';



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
  int start_height=1;
   double list_height;
  static double scrollbar_height=1;
  PreferredSize appbar;
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

                        Image.network("http://14.48.175.177/theme/basic_app/img/app/write_icon01.png"),
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
                        Image.network("http://14.48.175.177/theme/basic_app/img/app/write_icon02.png"),
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

  Widget get_content(id,cnt){

      InkWell temp = InkWell(
        child: Container(
          height: 100,
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
                  tag: id,
                  child: Container(
                    width: 90,
                    height: 80,
                    child:Image.asset("images/"+cnt+".jpg", ),
                  ),
                ),
                SizedBox(width: 10,),
                Column(

                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5,),
                    Text("테스트제목", style: TextStyle(fontSize: 12),),
                    SizedBox(height: 5,),
                    Text("무료나눔", style: TextStyle(fontSize: 12),),
                    SizedBox(height: 8,),
                    Row(
                      children: <Widget>[
                        Text("경기도 수원시 팔달구 구천동",style: TextStyle(fontSize: 10)),
                        SizedBox(width: 2,),
                        Text("2일전 ",style: TextStyle(fontSize: 10)),

                      ],

                    ),
                    SizedBox(height: 8,),
                    Text("건강/의료용품", style: TextStyle(fontSize: 8)),
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
                          border: Border.all(color: Color(0xffcccccc)),
                          image: DecorationImage(//이미지 꾸미기
                              fit:BoxFit.cover,
                              image:NetworkImage("http://forestmk.itforone.co.kr/data/member/3542386191_O4hMBHJf_d1f767e86e735db50a43847faef0544e41ede2ed.jpg")//이미지 가져오기
                          )
                      ),
                    ),
                    SizedBox(height: 6,),
                    Text("테스트",style: TextStyle(fontSize: 12),)
                  ],
                ),
              ],
            )
            ,
          ),
        ),

        onTap: (){
          Navigator.push(context,MaterialPageRoute(
              builder:(context) => Viewpage(tag:id, src:"images/"+cnt+".jpg")
          ));
        },
      );


      return temp;
  }

  @override
  void initState() {
    // TODO: implement initState
    appbar = intro_appbar;
    change_appbar.addListener(_changeappbar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
                          child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_cate01.png"),
                        ),
                        onTap: (){
                            Navigator.popUntil(context, (Route<dynamic> route) => false);
                        },
                      ),

                      InkWell(
                        child: Container(
                          width: 40,
                          height: scrollbar_height*0.8,
                          padding: EdgeInsets.all(3),
                          child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_cate02.png"),
                        ),
                        onTap: (){
                        },
                      ),

                      InkWell(
                        child: Container(
                          width: 40,
                          height: scrollbar_height*0.8,
                          padding: EdgeInsets.all(3),

                          child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_cate03.png"),
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

                          child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_cate04.png"),
                        ),
                        onTap: (){

                        },
                      ),

                      InkWell(
                        child: Container(
                          width: 40,
                          height: scrollbar_height*0.8,
                          padding: EdgeInsets.all(3),

                          child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_cate05.png"),
                        ),
                        onTap: (){

                        },
                      ),

                    ],
                  ),
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
                Container(
                height: MediaQuery.of(context).size.height*0.075,
                decoration: new BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Container(
                    padding:EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top:MediaQuery.of(context).size.height*0.01,bottom: MediaQuery.of(context).size.height*0.01),
                    child:Image.network("http://forestmk.itforone.co.kr/img/logo_name.png",fit: BoxFit.fill,),
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.09,
                          height: MediaQuery.of(context).size.width*0.09,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              border: Border.all(color: Color(0xffcccccc))
                          ),
                          child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_icon01.png"),
                        ),
                        onTap: (){

                        },
                      ),

                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.09,
                          height: MediaQuery.of(context).size.width*0.09,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              border: Border.all(color: Color(0xffcccccc))
                          ),
                          child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_icon02.png"),
                        ),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(
                              builder:(context) => location()
                          ));
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.09,
                          height: MediaQuery.of(context).size.width*0.09,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              border: Border.all(color: Color(0xffcccccc))
                          ),
                          child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_icon03.png"),
                        ),
                        onTap: (){

                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                    ],
                  )
                  ]
                )),
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
                            child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_cate01.png"),
                          ),
                          onTap: (){
                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_cate02.png"),
                          ),
                          onTap: (){

                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_cate03.png"),
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

                            child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_cate04.png"),
                          ),
                          onTap: (){

                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/hd_cate05.png"),
                          ),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(
                                builder:(context) => mypage()
                            ));
                          },
                        ),


                      ],
                    )),
                Container(
                    height: MediaQuery.of(context).size.height*0.08,
                    decoration: BoxDecoration(color: Colors.white),
                    padding:EdgeInsets.only(left: 22,right: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 45,
                                height: 45,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Color(0xfff3f3f3),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(color: Color(0xffcccccc))
                                ),
                                child: Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/wing_mb_noimg2.png"),
                              ),
                              onTap: (){

                              },
                            ),
                            SizedBox(width: 10,),
                            InkWell(
                              child: Text("로그인 후, 이용해주세요",style: TextStyle(color: Colors.black),),
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(
                                    builder:(context) => loginpage()
                                ));
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
                                  child:Image.network("http://forestmk.itforone.co.kr/theme/basic_app/img/app/mb_write_btn.png"),
                                ),
                                Text("글쓰기",style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                          onTap: (){
                            _showcontent();
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

                        Row(
                          children: <Widget>[
                            Text("최근순"),
                            Image.asset("images/arrow_filter.png"),
                          ],
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
                get_content("hero01", "01"),
                get_content("hero02", "02"),
                get_content("hero03", "03"),
                get_content("hero04", "04"),
                get_content("hero05", "05"),
                get_content("hero06", "06"),
                get_content("hero07", "07"),
                get_content("hero08", "08"),
                get_content("hero09", "09"),

              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.1,
            decoration: BoxDecoration(
                image: DecorationImage(//이미지 꾸미기
                    fit:BoxFit.cover,
                    image:NetworkImage("http://forestmk.itforone.co.kr/theme/basic_app/img/ft_bn.jpg")//이미지 가져오기
                )
            ),
          ),
        ],
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
