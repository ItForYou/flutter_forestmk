import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterforestmk/border/basicboard.dart';
import 'package:flutterforestmk/location.dart';
import 'package:flutterforestmk/main.dart';
import 'package:flutterforestmk/member/modify_info.dart';
import 'package:flutterforestmk/member/my_items.dart';
import 'package:flutterforestmk/member/mysetting.dart';
import 'package:flutterforestmk/search_info.dart';
import 'package:flutterforestmk/search_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class mypage extends StatefulWidget {

  String mb_name,mb_1,mb_2,mb_3,mb_4,mb_5,mb_6,mb_hp,mb_id,mb_pwd;
  mypage({Key key, this.mb_name, this.mb_1, this.mb_2,this.mb_6,this.mb_5,this.mb_4,this.mb_3,this.mb_hp,this.mb_id,this.mb_pwd}) : super(key: key);

  @override
  _mypageState createState() => _mypageState();
}

class _mypageState extends State<mypage> {

    void load_myinfo()async{
      SharedPreferences sp = await SharedPreferences.getInstance();
      if(sp.getString('id')!=null) {
       widget.mb_id = sp.getString('id');
       widget.mb_pwd = sp.getString('pwd');
        get_mbdata();
      }
    }

  Future<dynamic> get_mbdata() async{
    print("get_mbdata");
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_mb.php'),
        body: {
          "mb_id":widget.mb_id==null?'':widget.mb_id,
        },
        headers: {'Accept' : 'application/json'}
    );
    //print(jsonDecode(response.body));
    setState(() {
      var temp_mbdata = jsonDecode(response.body);
      if(widget.mb_1 != "http://14.48.175.177/data/member/"+temp_mbdata['mb_1'])
      {
        setState(() {
        });
      }
      widget.mb_hp = temp_mbdata['mb_hp'];
      widget.mb_name = temp_mbdata['mb_name'];
      if(temp_mbdata['mb_1']!='') {
        widget.mb_1 = "http://14.48.175.177/data/member/" + temp_mbdata['mb_1'];
      }
      else{
        widget.mb_1 = "test";
      }
      widget.mb_2 = temp_mbdata['mb_2'];
      widget.mb_3 = temp_mbdata['mb_3'];
      widget.mb_4 = temp_mbdata['mb_4'];
      widget.mb_5 = temp_mbdata['mb_5'];
      widget.mb_6 = temp_mbdata['mb_6'];
    });

  }



  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.03,
            child: Text("로그아웃 하시겠습니까?"),
          ),
          actions: <Widget>[

            new FlatButton(
              child: new Text("취소",style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("확인",style: TextStyle(color: Colors.forestmk),),
              onPressed: ()async {
                Navigator.pop(context);
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.clear();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()),
                        (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

  //  load_myinfo();
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,'back');
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("홈으로" ,style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: InkWell(
            child:Padding(
                padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.02, bottom: MediaQuery.of(context).size.height*0.02, left: MediaQuery.of(context).size.width*0.05),
                child:Image.asset("images/hd_back.png")
            ),
            onTap: (){
              Navigator.pop(context,'back');
            },
          ),
      ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.035,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffdddddd),width: 1),
                    )
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                      child:
                      Text("나의 메뉴", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),)
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.11,
                  padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.03,right:MediaQuery.of(context).size.width*0.03,),
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffdddddd),width: 1),
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width*0.12,
                              height: MediaQuery.of(context).size.width*0.12,
                              decoration: BoxDecoration(
                                  color: Color(0xfff3f3f3),
                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.5,)),
                                  border: Border.all(color: Color(0xffcccccc)),
                                  image: DecorationImage(//이미지 꾸미기
                                      fit:BoxFit.cover,
                                      image:widget.mb_1!='test'?NetworkImage(widget.mb_1):AssetImage("images/wing_mb_noimg2.png")//이미지 가져오기
                              ),
                            )
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(widget.mb_name,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,fontWeight: FontWeight.bold),),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.005,),
                                  Text(widget.mb_2, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03,),),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.23,
                          height: MediaQuery.of(context).size.width*0.06,
                          decoration: BoxDecoration(
                            color: Color(0xff444444),
                            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.5,)),
                          ),
                          child: Center(child: Text("프로필편집", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035, color: Colors.white), )),
                        ),
                        onTap: ()async{
                          var result = await  Navigator.push(context,MaterialPageRoute(
                              builder:(context) => modify_info(mb_name: widget.mb_name,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_hp: widget.mb_hp,mb_4:widget.mb_4,mb_5: widget.mb_5,mb_6: widget.mb_6,mb_id:widget.mb_id,)
                          ));
                          if(result == 'modify'){
                              get_mbdata();
                          }
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width*0.3,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Color(0xffdddddd)))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width*0.13,
                                height: MediaQuery.of(context).size.width*0.13,
                                decoration: BoxDecoration(
                                  color: Color(0xffeeeeee),
                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.5,),),
                                  ),
                                 child:Image.asset("images/my_icon01.png",),
                                ),
                            SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                            Text("판매내역",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03),)
                          ],
                        ),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(
                              builder:(context) => my_items(title:"판매중인 물건", mb_id:widget.mb_id,mb_pwd:widget.mb_pwd,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,)
                          ));
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                      InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width*0.13,
                              height: MediaQuery.of(context).size.width*0.13,
                              decoration: BoxDecoration(
                                color: Color(0xffeeeeee),
                                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.5,),),
                              ),
                              child: Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01), child:Image.asset("images/my_icon02.png",)),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                            Text("나의광고",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03),)
                          ],
                        ),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(
                              builder:(context) => my_items(title:"광고중인 게시글", mb_id:widget.mb_id,mb_pwd:widget.mb_pwd,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,)
                          ));
                        },
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.085,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1,color: Color(0xffdddddd)))
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width*0.1,
                          height: MediaQuery.of(context).size.width*0.1,
                          child: Image.asset("images/myul_icon01.png"),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                        Text("나의 위치 설정",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),)
                      ],
                    ),
                  ),
                  onTap: ()async{
                    var result = await    Navigator.push(context,MaterialPageRoute(
                        builder:(context) => location(mb_2: widget.mb_2,)
                    ));
                    if(result == 'change'){
                      get_mbdata();
                    }
                  },
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.075,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1,color: Color(0xffdddddd)))
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width*0.1,
                          height: MediaQuery.of(context).size.width*0.1,
                          child: Image.asset("images/myul_icon02.png"),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                        Text("숲마켓 공유",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),)

                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.075,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1,color: Color(0xffdddddd)))
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width*0.1,
                          height: MediaQuery.of(context).size.width*0.1,
                          child: Image.asset("images/myul_icon03.png"),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                        Text("공지사항",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),)

                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(
                        builder:(context) => basicboard(title: "공지사항",bo_table: 'notice',mb_id: widget.mb_id,mb_name: widget.mb_name,)
                    ));
                },
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.075,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1,color: Color(0xffdddddd)))
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width*0.1,
                          height: MediaQuery.of(context).size.width*0.1,
                          child: Image.asset("images/myul_icon04.png"),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                        Text("고객 문의",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),)

                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(
                        builder:(context) => basicboard(title: "고객문의",bo_table: 'qna',mb_name:widget.mb_name,mb_id: widget.mb_id,)
                    ));
                  },
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.075,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1,color: Color(0xffdddddd)))
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width*0.1,
                          height: MediaQuery.of(context).size.width*0.1,
                          child: Image.asset("images/myul_icon05.png"),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                        Text("앱 설정",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),)

                      ],
                    ),
                  ),
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => mysetting(mb_3:widget.mb_3, mb_hp : widget.mb_hp)
                      ));
                  },
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.075,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1,color: Color(0xffdddddd)))
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width*0.1,
                          height: MediaQuery.of(context).size.width*0.1,
                          child: Image.asset("images/myul_icon06.png"),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                        Text("로그아웃",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),)

                      ],
                    ),
                  ),
                  onTap: (){
                    _showDialog();
                  },
                ),
              ],
            ),
        ),

      ),
    );
  }
}
