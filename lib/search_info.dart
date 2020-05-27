


import 'package:flutter/material.dart';
import 'package:flutterforestmk/loginpage.dart';

class search_info extends StatefulWidget {

  @override
  _search_infoState createState() => _search_infoState();
}

class _search_infoState extends State<search_info> {

  Color on_tabcolor = Colors.forestmk;
  Color off_tabcolor = Colors.black;

  @override
  Widget build(BuildContext context) {
    String id = 'test01';
    Widget idContainer = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.15,
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Color(0xffdddddd)),
        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.03)),        
      ),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[          
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,
                  color: Colors.black),
              children: <TextSpan>[
                  TextSpan(text: "찾으시는 아이디는 "),
                  TextSpan(text: id, style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width*0.055,
                    color: Colors.forestmk
                  )),
                  TextSpan(text: "입니다.")
              ]
            ),
          ),
          InkWell(
            child: Text(
              "로그인 바로가기",
              style: TextStyle(
                  decoration: TextDecoration.underline
              ),
            ),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(
                  builder:(context) => loginpage()
              ));
            },
          )
        ],
      ),
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("홈으로" ,style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: InkWell(
            child:Padding(
                padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.02, bottom: MediaQuery.of(context).size.height*0.02, left: MediaQuery.of(context).size.width*0.05),
                child:Image.network("http://14.48.175.177/theme/basic_app/img/app/hd_back.png")
            ),
            onTap: (){
              Navigator.of(context).pop(true);
            },
          ),
          bottom:TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: <Widget>[
                  Tab(
                    text: "아이디 찾기",
                  ),
                  Tab(
                    text: "비밀번호 찾기",
                  ),
                ],
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.forestmk),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.06,right: MediaQuery.of(context).size.width*0.06, top:  MediaQuery.of(context).size.height*0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.03),
                    child: Text("아이디 찾기", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05)),
                  ),
                  Text("회원가입 시 등록하신 핸드폰번호를 입력해 주세요."),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  Container(
                    height: MediaQuery.of(context).size.height*0.08,
                    child: TextFormField(
                        cursorColor: Colors.forestmk,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff5f5f5),
                          contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                          hintText: "휴대번호",
                          border: null,
                          enabledBorder:OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                          ),
                        )
                    ),
                  ),
                  idContainer,
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.32,
                      height:MediaQuery.of(context).size.height*0.08,
                      decoration: BoxDecoration(
                          color: Color(0xff555555),
                          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.02))
                      ),
                      child: Center(child: Text("찾기", style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.05,),)),
                    ),
                  )

                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.06,right: MediaQuery.of(context).size.width*0.06, top:  MediaQuery.of(context).size.height*0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.03),
                    child: Text("비밀번호 찾기", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05)),
                  ),
                  Text("회원가입 시 등록하신 아이디와 휴대번호를 입력하시면,\n해당 휴대전화로 문자(비밀번호)가 전송됩니다."),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  Container(
                    height: MediaQuery.of(context).size.width*0.13,
                    child: TextFormField(
                        cursorColor: Colors.forestmk,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff5f5f5),
                          contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                          hintText: "아이디",
                          border: null,
                          enabledBorder:OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                          ),
                        )
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width*0.13,
                    child: TextFormField(
                        cursorColor: Colors.forestmk,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff5f5f5),
                          contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                          hintText: "휴대번호",
                          border: null,
                          enabledBorder:OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.32,
                      height:MediaQuery.of(context).size.height*0.08,                     
                      decoration: BoxDecoration(
                        color: Color(0xff555555),
                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.02))
                      ),
                      child: Center(child: Text("찾기", style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.05,),)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
