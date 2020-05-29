import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterforestmk/changehp.dart';

class mysetting extends StatefulWidget {

  String mb_name,mb_1,mb_2,mb_3,mb_4,mb_5,mb_6,mb_hp,mb_id;
  mysetting({Key key, this.mb_name, this.mb_1, this.mb_2,this.mb_6,this.mb_5,this.mb_4,this.mb_3,this.mb_hp,this.mb_id}) : super(key: key);

  @override
  _mysettingState createState() => _mysettingState();
}

class _mysettingState extends State<mysetting> {

  bool  switchvalue1=true, switchvalue2=true;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(

            height: MediaQuery.of(context).size.height*0.049,
            child: Text("회원님의 게시물과 모든 정보들이 삭제됩니다.\t숲마켓을 탈퇴하시겠습니까?", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.022,),),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);

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
                Navigator.push(context,MaterialPageRoute(
                    builder:(context) => changehp()
                ));
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
            Container(
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
