import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterforestmk/categorypage.dart';
import 'package:flutterforestmk/chk_writead.dart';
import 'package:flutterforestmk/location.dart';
import 'package:flutterforestmk/loginpage.dart';
import 'package:flutterforestmk/main.dart';
import 'package:flutterforestmk/mypage.dart';
import 'package:flutterforestmk/viewpage.dart';
import 'package:flutterforestmk/write_normal.dart';


class my_items extends StatefulWidget {

  final String title;

  my_items({Key key, this.title,}) : super(key: key);

  @override
  _my_itemsState createState() => _my_itemsState();
}

class _my_itemsState extends State<my_items> {



  static double scrollbar_height=1;
  double list_height;
  int start_height=1;
  ScrollController change_appbar = ScrollController();
  PreferredSize appbar;
  List <bool> checkbox_values = List<bool>();
  bool flg_allcheck = false;
  PreferredSize intro_appbar = PreferredSize(
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
      preferredSize:Size.fromHeight(0),
      child:AppBar(
        automaticallyImplyLeading: false,
        title: null,
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions:null,
      )
  );
  PreferredSize scroll_appbar;

  _changeappbar() {

    double scrollposition = change_appbar.position.pixels;

    if (scrollposition > 100) {
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
        //실값이 반올림되어져 비교되어짐 그래서 값이 다르게 나옴
        /*if(list_height  == MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.23) {

         }*/
      });
    }
  }

  Widget get_content(id,cnt,chk_id){

    if(start_height == 1)
    checkbox_values.add(false);

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
                    Checkbox(
                      value: checkbox_values[chk_id],
                      activeColor: Colors.black12,
                      onChanged: (bool value){
                        print(chk_id.toString());

                        setState(() {
                          checkbox_values[chk_id] = value;
                          print(checkbox_values[chk_id].toString());
                        });
                      },
                    ),
                    Hero(
                      tag: id,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.27,
                        height: MediaQuery.of(context).size.height*0.2,
                        child:Image.asset("images/"+cnt+".jpg", ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(

                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5,),
                        Text("테스트제목", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),),
                        SizedBox(height: 5,),
                        Text("무료나눔", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),),
                        SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text("경기도 수원시 팔달구 구천동",style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)),
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
                            Text("2일전 ",style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)),

                          ],

                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.006,),
                        Row(
                          children: <Widget>[
                            Text("건강/의료용품", style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)),
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
                            Text("1", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.026,)),
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
      list_height = MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.049;
      scrollbar_height = MediaQuery.of(context).size.height*0.08;
      scroll_appbar = PreferredSize(
          preferredSize: Size.fromHeight(scrollbar_height),
          child: AppBar(
            automaticallyImplyLeading: false,
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
                        Navigator.push(context,MaterialPageRoute(
                            builder:(context) => MyApp()
                        ));
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
                        Navigator.push(context,MaterialPageRoute(
                            builder:(context) => mypage()
                        ));
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
                            child:Image.asset("images/logo_name.png",fit: BoxFit.fill,),
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
                                  child: Image.asset("images/hd_icon01.png"),
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
                                  child: Image.asset("images/hd_icon02.png"),
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
                                  child: Image.asset("images/hd_icon03.png"),
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
                            Navigator.push(context,MaterialPageRoute(
                                builder:(context) => my_items(title: "최근 본 글",)
                            ));
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
                                child: Image.asset("images/wing_mb_noimg2.png"),
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
                                  child:Image.asset("images/mb_write_btn.png"),
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
                            Text(widget.title ,style: TextStyle(fontWeight: FontWeight.bold, fontSize:MediaQuery.of(context).size.width*0.045)),
                        Row(
                          children: <Widget>[

                            InkWell(
                                child: Text("모두선택",style: TextStyle(color: Colors.forestmk),),
                                onTap: (){
                                  setState(() {
                                    bool all_value;
                                    if(flg_allcheck==false) {
                                            flg_allcheck=true;
                                            all_value = true;
                                      }
                                    else{
                                      flg_allcheck=false;
                                      all_value = false;
                                    }

                                      for (int i = 0; i < checkbox_values.length; i++) {
                                        checkbox_values[i] = all_value;
                                    }
                                  });
                                },
                            ),
                            SizedBox(width:  MediaQuery.of(context).size.width*0.03,),
                            InkWell(
                                child: Text("지우기",style: TextStyle(color: Colors.forestmk),),
                                onTap: (){

                                },
                            ),
                          ],
                        ),
                      ],
                    )

                ),
                get_content("hero01", "01",0),
                get_content("hero02", "02",1),
                get_content("hero03", "03",2),
                get_content("hero04", "04",3),
                get_content("hero05", "05",4),
                get_content("hero06", "06",5),
                get_content("hero07", "07",6),
                get_content("hero08", "08",7),
                get_content("hero09", "09",8),
              ],
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
