import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterforestmk/member/block_list.dart';
import 'package:flutterforestmk/member/changehp.dart';
import 'package:flutterforestmk/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class mysetting extends StatefulWidget {

  String mb_name,mb_1,mb_2,mb_3,mb_4,mb_5,mb_6,mb_hp,mb_id;
  mysetting({Key key, this.mb_name, this.mb_1, this.mb_2,this.mb_6,this.mb_5,this.mb_4,this.mb_3,this.mb_hp,this.mb_id}) : super(key: key);

  @override
  _mysettingState createState() => _mysettingState();
}

class _mysettingState extends State<mysetting> {

  bool  switchvalue1=true, switchvalue2=true;

  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.getString('id')!=null) {
      widget.mb_id = sp.getString('id');
    }
    load_state();
  }

  Future<String> update_state(flg,value) async{


    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_state.php'),
        body: {
              "flg": flg.toString(),
              "value":value.toString(),
              "mb_id":widget.mb_id==null?'':widget.mb_id
        },
        headers: {'Accept' : 'application/json'}
    );

  }

  Future<String> load_state() async{


    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_state.php'),
        body: {
            "mb_id":widget.mb_id==null?'':widget.mb_id
        },
        headers: {'Accept' : 'application/json'}
    );

    if(response.statusCode==200){
      var temp = jsonDecode(response.body);
      setState(() {
        if(temp['fcm_flg']=="1"){
          switchvalue1=true;
        }
        else{
          switchvalue1=false;
        }
        if(temp['flg_notice']=="1"){
          switchvalue2=true;
        }
        else{
          switchvalue2=false;
        }
      });

    }
  }



  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(

            height: MediaQuery.of(context2).size.height*0.049,
            child: Text("회원님의 게시물과 모든 정보들이 삭제됩니다.\t숲마켓을 탈퇴하시겠습니까?", style: TextStyle(fontSize: MediaQuery.of(context2).size.height*0.022,),),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: () async {
                final response = await http.post(
                    Uri.encodeFull('http://14.48.175.177/delete_member.php'),
                    body: {
                      "mb_id":widget.mb_id
                    },
                    headers: {'Accept' : 'application/json'}
                );
                if(response.statusCode ==200){
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.clear();
                  Navigator.pop(context2);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyApp()),
                          (Route<dynamic> route) => false);
                }
              },
            ),
            new FlatButton(
              child: new Text("취소"),
              onPressed: () {
                Navigator.pop(context2);
              },
            ),
          ],
        );
      },
    );
  }

  void logout_modal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.02,
            child: Text("로그아웃 하시겠습니까?"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: ()async {
                Navigator.pop(context);
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.clear();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()),
                        (Route<dynamic> route) => false);
              },
            ),
            new FlatButton(
              child: new Text("취소"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void show_Alert(text,flg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.02,
            child: Text(text),
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

  @override
  void initState() {
    // TODO: implement initState
    print(widget.mb_3);
    load_myinfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("나의 메뉴" ,style: TextStyle(color: Colors.black),),
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
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.06,
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03, top: MediaQuery.of(context).size.height*0.03),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Color(0xfffbbbbbb)))
              ),
              child: Text("앱설정",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,),),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.063,
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03,),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xffe8e8e8)))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("댓글, 채팅 알람",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,color: Color(0xffaaaaaa)),),
                  Switch(
                    value: switchvalue1,
                    onChanged: (value){
                      setState(() {
                        switchvalue1 = value;
                        update_state(1,value);
                      });
                    },
                    activeTrackColor: Colors.forestmk,
                    activeColor: Colors.white,
                  )

                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.063,
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03,),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xffe8e8e8)))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("공지사항 알람",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,color: Color(0xffaaaaaa)),),
                  Switch(
                    value: switchvalue2,
                    onChanged: (value){
                      setState(() {
                        switchvalue2 = value;
                        update_state(2,value);
                      });
                    },
                    activeTrackColor: Colors.forestmk,
                    activeColor: Colors.white,
                  )

                ],
              ),
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.063,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Color(0xffe8e8e8)))
                ),
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03,),
                child:  Row(
                  children: <Widget>[
                    Text("차단 사용자관리",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),),
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(
                    builder:(context) => block_list()
                ));
              },
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.063,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Color(0xffe8e8e8)))
                ),
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03,),
                child:  Row(
                  children: <Widget>[
                    Text("휴대폰 번호 변경하기 (1회)",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),),
                  ],
                ),
              ),
              onTap: (){
                if(widget.mb_3==0.toString()) {
                  Navigator.push(context,MaterialPageRoute(
                      builder:(context) => changehp(mb_hp:widget.mb_hp)
                  ));
                }
                else{
                  show_Alert("이미 1회 변경 하였습니다.",1);
                }
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.01,
              color: Color(0xfff9f9f9),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.08,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xffbbbbbb)))
              ),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03,top: MediaQuery.of(context).size.height*0.04,),
              child: Row(
                children: <Widget>[
                  Text("기타",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.063,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xffe8e8e8)))
              ),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03,),
              child: Row(
                children: <Widget>[
                  Text("버전 1.0",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, color: Color(0xffaaaaaa),)),
                ],
              ),
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.063,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Color(0xffe8e8e8)))
                ),
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03,),
                child: Row(
                  children: <Widget>[
                    Text("로그아웃",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,)),
                  ],
                ),
              ),
              onTap: (){
                logout_modal();
              },
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.063,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Color(0xffe8e8e8)))
                ),
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03,),
                child: Row(
                  children: <Widget>[
                    Text("회원탈퇴",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,)),
                  ],
                ),
              ),
              onTap: (){
                _showDialog();
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.01,
              color: Color(0xfff9f9f9),
            )
          ],
        ),
      ),
    );
  }
}
