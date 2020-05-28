


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterforestmk/viewpage_mine.dart';
import 'package:http/http.dart' as http;

class Viewpage_mine extends StatefulWidget {
  String tag,wr_id;
  Viewpage_mine({Key key, this.title, this.tag, this.wr_id}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ViewpagemineState createState() => _ViewpagemineState();
}

class _ViewpagemineState extends State<Viewpage_mine>{

  var itemdata;
  double itmes_height=0,itmes_height2=0;
  List <Widget> list_subitem = [Container()];
  List <Widget> list_extraitem = [Container()];

  Widget get_content2(id,cnt){

    InkWell temp = InkWell(
      child: Container(
        height: MediaQuery.of(context).size.height*0.25,
        width: MediaQuery.of(context).size.width*0.45,
        decoration: BoxDecoration(color: Colors.white),

        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*0.4,
                      height:  MediaQuery.of(context).size.height*0.15,
                      child:Image.asset("images/"+cnt+".jpg", fit: BoxFit.fill,),
                    ),

                    SizedBox(height: 5,),
                    Text("테스트제목", style: TextStyle(fontSize: 12),),
                    SizedBox(height: 5,),
                    Text("무료나눔", style: TextStyle(fontSize: 15),),
                  ]
              ),
            ],
          )
          ,
        ),
      ),

      onTap: (){
        /*Navigator.push(context,MaterialPageRoute(
            builder:(context) => Viewpage_mine(src:"images/"+cnt+".jpg")
        ));*/
      },
    );
    return temp;
  }

  Future<dynamic> get_data() async{
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_view.php'),
        body: {
          "wr_id" :widget.wr_id,
        },
        headers: {'Accept' : 'application/json'}
    );
    setState(() {
      //print("test");
      itemdata = jsonDecode(response.body);
      set_items();
    });

  }
  void set_items(){
    //print(itemdata['data'][0]);
    if(itemdata['data'].length > 0) {
      itmes_height = MediaQuery.of(context).size.height*0.355;
      list_subitem.clear();
      for (var i = 0; i < itemdata['data'].length; i++) {
        list_subitem.add(get_content2(i,1));
      }
    }

    if(itemdata['data2'].length > 0) {
      itmes_height2 = MediaQuery.of(context).size.height*0.35;
      list_extraitem.clear();
      for (var i = 0; i < itemdata['data2'].length; i++) {
        list_extraitem.add(get_content2(i,2));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text("가격정보" ,style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          leading: InkWell(

            child:Padding(
                padding: EdgeInsets.all(13),
                child:Image.asset("images/hd_back.png")
            ),
            onTap: (){
              Navigator.of(context).pop(true);
            },
          ),
          actions : <Widget>[
            RaisedButton(
              color: Color(0xfffae100),
              onPressed: (){},
              child: Text("1:1채팅"),
              textColor: Colors.black,
            )
          ]
      ),
      body:
      ListView(
        children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height*0.33,
                width: MediaQuery.of(context).size.width,
                child:Image.asset(widget.wr_id,fit: BoxFit.fitWidth,) ,
              ),
          Container(
            height: MediaQuery.of(context).size.height*0.13,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
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
                    SizedBox(width: 3,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("테스트사용자",style: TextStyle(fontSize: 16, fontWeight:  FontWeight.bold),),
                        SizedBox(height: 8,),
                        Text("부산광역시 수영구 광안동",style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*0.17,
                      height: MediaQuery.of(context).size.height*0.055,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(23)),
                          border: Border.all(color: Color(0xffcccccc)),
                          color: Color(0xff515151)
                      ),
                      child: Column(
                        children: <Widget>[
                          Image.asset("images/write_icon01.png",   width: MediaQuery.of(context).size.width*0.08, height: MediaQuery.of(context).size.height*0.027,),
                          Text("완료하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.025,color: Colors.white),)
                        ],
                      ),
                    ),
                    SizedBox(width: 3,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.17,
                      height: MediaQuery.of(context).size.height*0.055,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(23)),
                          border: Border.all(color: Color(0xffcccccc)),
//                              image: DecorationImage(//이미지 꾸미기
//                                  fit:BoxFit.cover,
//                                  image:NetworkImage("http://forestmk.itforone.co.kr/data/member/3542386191_O4hMBHJf_d1f767e86e735db50a43847faef0544e41ede2ed.jpg")//이미지 가져오기
//                              )
                          color: Color(0xff515151)
                      ),
                      child: Column(
                        children: <Widget>[
                          Image.asset("images/fa-siren-on.png",   width: MediaQuery.of(context).size.width*0.08, height: MediaQuery.of(context).size.height*0.027,),
                          Text("신고하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.025,color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 10, bottom: 10),
            height: MediaQuery.of(context).size.height*0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("테스트제목",style: TextStyle(fontSize: 20),),
                    SizedBox(height: 10,),
                    Row(
                        children:<Widget>[
                          Text("글쓴날짜",style: TextStyle(fontSize: 10),),
                          SizedBox(width: 2,),
                          Text("카테고리",style: TextStyle(fontSize: 10),),
                        ]
                    )


                  ],
                ),

                Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color:Color(0xffdddddd)),
                            color: Color(0xffffffff),
                          ),
                          width: 35,
                          height: 35,
                          child: Center(child:Text("수정", style: TextStyle(),),)
                      ),
                    ),
                    SizedBox(width: 3,),
                    InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color:Color(0xffdddddd)),
                            color: Color(0xffffffff),
                          ),
                          width: 35,
                          height: 35,
                          child: Center(child:Text("삭제", style: TextStyle(),),)
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.2,
            child: Text("testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest"),

          ),
          Container(
            height: MediaQuery.of(context).size.height*0.05,
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Text("좋아요",style: TextStyle(fontSize: 11),),
                SizedBox(width: 3,),
                Text("1",),
                SizedBox(width: 3,),
                Text("댓글",style: TextStyle(fontSize: 11),),
                Text("2"),
                SizedBox(width: 3,),
                Text("조회수",style: TextStyle(fontSize: 11),),
                SizedBox(width: 3,),
                Text("33"),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
            height: MediaQuery.of(context).size.height*0.07,
            decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 1,color: Color(0xffefefef)), bottom: BorderSide(width: 1,color: Color(0xffefefef)),)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[

                    Container(
                        width:MediaQuery.of(context).size.width*0.05,
                        child: Image.asset("images/fa-heart.png")
                    ),
                    Text("좋아요"),

                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width:MediaQuery.of(context).size.width*0.05,
                        child: Image.asset("images/fa-comment-alt.png")
                    ),
                    Text("댓글 달기"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width:MediaQuery.of(context).size.width*0.05,
                        child: Image.asset("images/fa-share.png")
                    ),
                    Text("공유하기"),
                  ],
                ),

              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.355,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1,color: Color(0xffefefef)))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height*0.1,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: MediaQuery.of(context).size.height*0.03,),
                  child: Text("테스트님의 판매상품",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.25,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.055,),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: list_subitem,
                  ),
                ),

              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height*0.1,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: MediaQuery.of(context).size.height*0.03,),
                  child: Text("관련상품",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.25,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.055,),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: list_extraitem,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
