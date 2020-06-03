
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class block_list extends StatefulWidget {
  @override
  _block_listState createState() => _block_listState();
}

class _block_listState extends State<block_list> {

  List <Widget> list_blocks=[];
  String real_mbid;
  var itemdata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_myinfo();

  }

  void show_unblock(block_id) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.02,
            child: Text("차단을 해제하시겠습니까?"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: (){
                  update_unblock(block_id, context);
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

  Future<dynamic> update_unblock(value,popcontext) async{
  print(value);
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_block.php'),
        body: {
          "block_id":value,
          "mb_id":real_mbid,
          "flg":2.toString()
        },
        headers: {'Accept' : 'application/json'}
    );
    if(response.statusCode==200){
      setState(() {
          get_data();
          Navigator.pop(popcontext);
      });
    }
  }

  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.getString('id')!=null) {
      real_mbid = sp.getString('id');
    }
    get_data();
  }

  Future<dynamic> get_data() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_blocks.php'),
        body: {
          "mb_id":real_mbid,
        },
        headers: {'Accept' : 'application/json'}
    );

      setState(() {

        if(response.body!='[]')
        itemdata = jsonDecode(response.body);

        list_blocks.clear();
        _getblocks();
      });


  }
  void _getblocks(){

    Widget title_widget =
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.05,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02,),
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1,color: Color(0xffdddddd)))
      ),
      child: Align(alignment:Alignment.centerLeft,child:Text("차단 사용자 관리", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)),
    );
    list_blocks.add(title_widget);

    if(itemdata==null){

      Widget temp =Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.08,
        child: Center(child: Text("차단된 목록이 없습니다."),),
      );
      list_blocks.add(temp);
    }
    else {
      for (int i = 0; i < itemdata.length; i++) {
        Widget temp =
        Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.08,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffdddddd)))
            ),

            padding: EdgeInsets.only(left: MediaQuery
                .of(context)
                .size
                .width * 0.05, right: MediaQuery
                .of(context)
                .size
                .width * 0.05),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.1,
                          height: MediaQuery
                              .of(context)
                              .size
                              .width * 0.1,
                          margin: EdgeInsets.only(
                              top: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.005,
                              bottom: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.005),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50)),
                              color: Color(0xfff3f3f3),
                              image: DecorationImage( //이미지 꾸미기
                                fit: BoxFit.cover,
                                image: itemdata[i]['mb_1'] != '' ? NetworkImage(
                                    itemdata[i]['mb_1']) : AssetImage(
                                    "images/wing_mb_noimg2.png"), //이미지 가져오기
                              )
                          )
                      ),
                      SizedBox(width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.02,),
                      Text(itemdata[i]['mb_name']),
                    ],
                  ),
                  InkWell(child: Icon(Icons.close, color: Colors.black,),
                    onTap: () {
                      show_unblock(itemdata[i]['block_id']);
                    },

                  )
                ]
            )
        );

        list_blocks.add(temp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("나의 메뉴" ,style: TextStyle(color: Colors.black),),
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
      body: SingleChildScrollView(
        child: Column(
          children:
          list_blocks,
        ),
      ),

    );
  }
}
