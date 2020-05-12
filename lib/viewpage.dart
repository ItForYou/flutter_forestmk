


import 'package:flutter/material.dart';
import 'package:flutterforestmk/viewpage_mine.dart';

class Viewpage extends StatefulWidget {
  String tag,src;
  Viewpage({Key key, this.title, this.tag, this.src}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ViewpageState createState() => _ViewpageState();
}

class _ViewpageState extends State<Viewpage>{


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
        Navigator.push(context,MaterialPageRoute(
            builder:(context) => Viewpage_mine(src:"images/"+cnt+".jpg")
        ));
      },
    );
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text("가격정보" ,style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            leading: InkWell(
              
              child:Padding(
                padding: EdgeInsets.all(13),
                child:Image.network("http://14.48.175.177/theme/basic_app/img/app/hd_back.png")
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
              Hero(
                    tag: widget.tag,
                    child:  Container(
                                  height: MediaQuery.of(context).size.height*0.33,
                                  width: MediaQuery.of(context).size.width,
                                  child:Image.asset(widget.src,fit: BoxFit.fitWidth,) ,
                    )
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
                          width: 60,
                          height: MediaQuery.of(context).size.height*0.08,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(23)),
                              border: Border.all(color: Color(0xffcccccc)),
                              image: DecorationImage(//이미지 꾸미기
                                  fit:BoxFit.cover,
                                  image:NetworkImage("http://forestmk.itforone.co.kr/data/member/3542386191_O4hMBHJf_d1f767e86e735db50a43847faef0544e41ede2ed.jpg")//이미지 가져오기
                              )
                          ),
                        ),
                        SizedBox(width: 3,),
                        Container(
                          width: 60,
                          height: MediaQuery.of(context).size.height*0.08,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(23)),
                              border: Border.all(color: Color(0xffcccccc)),
                              image: DecorationImage(//이미지 꾸미기
                                  fit:BoxFit.cover,
                                  image:NetworkImage("http://forestmk.itforone.co.kr/data/member/3542386191_O4hMBHJf_d1f767e86e735db50a43847faef0544e41ede2ed.jpg")//이미지 가져오기
                              )
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[

                          Container(
                              width:MediaQuery.of(context).size.width*0.05,
                              child: Image.network("http://14.48.175.177/theme/basic_app/img/app/myul_icon03.png")
                          ),
                          Text("좋아요"),

                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width:MediaQuery.of(context).size.width*0.05,
                              child: Image.network("http://14.48.175.177/theme/basic_app/img/app/myul_icon03.png")
                          ),
                          Text("댓글 달기"),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width:MediaQuery.of(context).size.width*0.05,
                              child: Image.network("http://14.48.175.177/theme/basic_app/img/app/myul_icon03.png")
                          ),
                          Text("공유하기"),
                        ],
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
                      child: Text("테스트님의 판매상품",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.25,
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.055,),
                      child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                get_content2("another_mine1", "01"),
                                get_content2("another_mine2", "02"),
                              ],
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
                        children: <Widget>[
                          get_content2("another_mine1", "01"),
                          get_content2("another_mine2", "02"),
                        ],
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
