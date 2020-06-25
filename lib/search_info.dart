


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterforestmk/member/loginpage.dart';
import 'package:http/http.dart' as http;

class search_info extends StatefulWidget {

  @override
  _search_infoState createState() => _search_infoState();
}

class _search_infoState extends State<search_info> {

  Color on_tabcolor = Colors.forestmk;
  Color off_tabcolor = Colors.black;
  bool flg_searchbt = false, flg_searchsuccess=false;
  var info_data;
  TextEditingController input_hp = TextEditingController();
  TextEditingController input_schpwdid = TextEditingController();
  TextEditingController input_schpwdhp = TextEditingController();
  String id ='';

  Future<dynamic> get_searchinfo() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/search_info.php'),
        body: {
            "mb_hp": input_hp.text,
            "flg" : 1.toString()
        },
        headers: {'Accept' : 'application/json'}
    );

    //print(response.body);

    if(response.statusCode ==200) {
      setState(() {

        info_data = jsonDecode(response.body);

        if(info_data['data'].length <=0) {
          flg_searchbt = true;
          flg_searchsuccess = false;
        }
        else{
          flg_searchsuccess = true;
          id = info_data['data'][0]['mb_id'];
          flg_searchbt = true;
        }
      });
    }
  }

  void show_Alert(text,flg) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.03,
            child: Text(text),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: ()async{

                if(flg ==2){
                  Navigator.of(context).pop(true);
                  Navigator.of(context2).pop(true);
                }
                else{
                  Navigator.of(context2).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> get_password() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/search_info.php'),
        body: {
          "mb_hp": input_schpwdhp.text,
          "mb_id" : input_schpwdid.text,
          "flg":2.toString()
        },
        headers: {'Accept' : 'application/json'}
    );

    //print(response.body);

    if(response.statusCode ==200) {

       print(response.body);
       if(response.body.toString()=='hpnone'){
         show_Alert("핸드폰 번호가 일치하지 않습니다." ,1);
       }
       else if (response.body.toString()=='none'){
         show_Alert("아이디가 존재하지 않습니다.", 1);
       }

    }
  }


  @override
  Widget build(BuildContext context) {
    Widget idContainer = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.18,
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Color(0xffdddddd)),
        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.03)),        
      ),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          flg_searchsuccess==true?
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,
                  color: Colors.black),
              children: <TextSpan>[
                  TextSpan(text: "찾으시는 아이디는 ", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.032)),
                  TextSpan(text: id, style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width*0.055,
                    color: Colors.forestmk
                  )),
                  TextSpan(text: "입니다.",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.032))
              ]
            ),
          ):Text("찾으시는 아이디가 없습니다."),
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
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.6,
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
                          controller: input_hp,
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
                    flg_searchbt==true?
                    idContainer:SizedBox(),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Center(
                      child: InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.32,
                          height:MediaQuery.of(context).size.height*0.08,
                          decoration: BoxDecoration(
                              color: Color(0xff555555),
                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.02))
                          ),
                          child: Center(child: Text("찾기", style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.05,),)),
                        ),
                        onTap: (){
                          get_searchinfo();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.6,
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
                          controller: input_schpwdid,
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
                          controller: input_schpwdhp,
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
                    InkWell(
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.32,
                          height:MediaQuery.of(context).size.height*0.08,
                          decoration: BoxDecoration(
                            color: Color(0xff555555),
                            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.02))
                          ),
                          child: Center(child: Text("찾기", style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.05,),)),
                        ),
                      ),
                      onTap: (){
                        get_password();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
