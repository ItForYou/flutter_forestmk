
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterforestmk/main.dart';
import 'package:flutterforestmk/main_home.dart';
import 'package:flutterforestmk/search_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class categorypage  extends StatefulWidget {
  String mb_name,mb_1,mb_2,mb_3,mb_4,mb_5,mb_6,mb_hp,mb_id,mb_pwd;
  categorypage({Key key, this.mb_name, this.mb_1, this.mb_2,this.mb_6,this.mb_5,this.mb_4,this.mb_3,this.mb_hp,this.mb_id,this.mb_pwd}) : super(key: key);
  @override
  _categorypageState createState() => _categorypageState();
}

class _categorypageState extends State<categorypage> {

  var menu_names = ["전체보기", "생활용품", "여성의류", "가구/인테리어", "여성잡화", "디지털/가전","남성의류", "자동차/오토바이","남성잡화",
                    "게임/취미","유아용품","스포츠/레저","뷰티/미용","도서","반려동물용품","식품","건강/의료용품","기타물품","부동산",];


  Widget getitems(id){

    String path_img=""+id.toString();
    if(id <10){
      path_img  = "0"+id.toString();
    }
    else{
      path_img  = id.toString();
    }
    Widget temp = InkWell(
        child:Container(
        decoration : id%2 ==0? BoxDecoration(border: Border(right: BorderSide( color: Color(0xffdddddd),width: 1))):null,
        width: MediaQuery.of(context).size.width*0.5,
        height: MediaQuery.of(context).size.height*0.08,
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.055, top: 10,bottom: 10,),
        child:Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/category"+path_img+".png"),
              Text(menu_names[id])
            ],
          ),
        ),
      onTap: (){
          if(id ==0)
            Navigator.push(context,MaterialPageRoute(
                builder:(context) => main_home(mb_id: widget.mb_id,)
            ));
          else {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => search_main(sch_cate: menu_names[id] , mb_id:widget.mb_id,mb_pwd:widget.mb_pwd,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,)
            ));
          }
      },
    );

    return temp;
  }

  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.getString('id')!=null) {
      get_mbdata();
    }
  }

  Future<dynamic> get_mbdata() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_mb.php'),
        body: {
          "mb_id":widget.mb_id==null?'':widget.mb_id,
        },
        headers: {'Accept' : 'application/json'}
    );
    //print(jsonDecode(response.body));

    var temp_mbdata = jsonDecode(response.body);
    widget.mb_hp = temp_mbdata['mb_hp'];
    widget.mb_name = temp_mbdata['mb_name'];
    if(temp_mbdata['mb_1']!='') {
      widget.mb_1 = "http://14.48.175.177/data/member/" + temp_mbdata['mb_1'];
    }
    else{
      widget.mb_1='test';
    }
    widget.mb_2 = temp_mbdata['mb_2'];
    widget.mb_3 = temp_mbdata['mb_3'];
    widget.mb_4 = temp_mbdata['mb_4'];
    widget.mb_5 = temp_mbdata['mb_5'];
    widget.mb_6 = temp_mbdata['mb_6'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_myinfo();
  }

  @override
  Widget build(BuildContext context) {

   // load_myinfo();
    return Scaffold(
      appBar: AppBar(
          title: Text("홈으로" ,style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: InkWell(

            child:Padding(
                padding: EdgeInsets.all(13),
                child:Image.asset("images/hd_back.png")
            ),
            onTap: (){
              Navigator.of(context).pop(true);
            },

          ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
              Container(
                width:  MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.05,
                padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.01, bottom: MediaQuery.of(context).size.height*0.01, left: MediaQuery.of(context).size.width*0.06,),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xffdddddd))),color: Colors.white),
                child: Text("카테고리", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.025, ),),
              ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.825,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      getitems(0),
                      getitems(2),
                      getitems(4),
                      getitems(6),
                      getitems(8),
                      getitems(10),
                      getitems(12),
                      getitems(14),
                      getitems(16),
                      getitems(18),

                    ],
                  ),
                  Column(
                    children: <Widget>[
                      getitems(1),
                      getitems(3),
                      getitems(5),
                      getitems(7),
                      getitems(9),
                      getitems(11),
                      getitems(13),
                      getitems(15),
                      getitems(17),
                    ],
                  )

                ],
              ),

            )
          ],
        ),
      ),

    );
  }
}
