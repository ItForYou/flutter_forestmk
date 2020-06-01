import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterforestmk/basic_item.dart';
import 'package:flutterforestmk/write_basic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class basicview extends StatefulWidget {
  final String title,bo_table,mb_id,mb_name;
  final basic_item item;
  basicview({Key key, this.title,this.item,this.bo_table, this.mb_id,this.mb_name}) : super(key: key);

  @override
  _basicviewState createState() => _basicviewState();
}

class _basicviewState extends State<basicview> {

  double comment_height;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.05,
            child: Text("한번 삭제한 자료는 복구할 방법이 없습니다.\n정말 삭제하시겠습니까?"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: (){
                delete_data();
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

  Future<dynamic> delete_data() async{
    print(widget.bo_table);
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/delete_wr.php'),
        body: {
          "wr_id":widget.item.wr_id!=null?widget.item.wr_id:'',
          "bo_table":widget.bo_table!=null?widget.bo_table:'',
        },
        headers: {'Accept' : 'application/json'}
    );

      if(response.statusCode==200){
        Navigator.pop(context);
          Navigator.pop(context,"delete");

      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    comment_height=  MediaQuery.of(context).size.height*0.03;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title ,style: TextStyle(color: Colors.black),),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.08,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1, top: MediaQuery.of(context).size.height*0.05),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Color(0xffd9d9d9)))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.item.wr_subject,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05,),),
                  SizedBox(height: MediaQuery.of(context).size.height*0.005,),
                  Text(widget.item.wr_datetime + " 조회 "+ widget.item.wr_hit+ " 댓글 "+widget.item.comments,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03,),),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.35,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1, ),
              child: Align(alignment: Alignment.topLeft,child: Text(widget.item.wr_content)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.07,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1, ),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.03),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1,color: Color(0xffd9d9d9)))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.12,
                      height: MediaQuery.of(context).size.height*0.08,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xffd9d9d9))
                      ),
                      child: Center(child: Text("수정")),
                    ),
                     onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                           builder: (context) => write_basic(title: widget.title,info: widget.item,mb_id: widget.mb_id,mb_name: widget.mb_name,w: 'u',bo_table: widget.bo_table,)
                       ));
                     },
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02),
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.12,
                      height: MediaQuery.of(context).size.height*0.08,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Color(0xffd9d9d9))
                      ),
                      child: Center(child: Text("삭제")),
                    ),
                    onTap: (){
                      _showDialog();
                    },
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02),
                  Container(
                    width: MediaQuery.of(context).size.width*0.12,
                    height: MediaQuery.of(context).size.height*0.08,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xffd9d9d9))
                    ),
                    child: Center(child: Text("목록")),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.07,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1, ),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.03),
              child: Row(
                children: <Widget>[
                  Image.asset("images/fa-comment-alt.png"),
                  Text(" 댓글", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,),)
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: comment_height,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1, ),
              child: Center(child: Text("등록된 댓글이 없습니다.")),
            ),

            Container(
              width: MediaQuery.of(context).size.width*0.85,
              height: MediaQuery.of(context).size.height*0.17,
              margin:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05,),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1,bottom: MediaQuery.of(context).size.height*0.01 ),

              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Color(0xffdddddd))
              ),
              child: Column(
                children: <Widget>[

                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: MediaQuery.of(context).size.height*0.13,
                    child: TextFormField(
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none
                        ),
                    ),
                  ),
                  Align(alignment: Alignment.bottomRight,child: Text("댓글게시",style: TextStyle(color: Color(0xff20e4c5)),))
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.1,)

          ],
        ),
      ),


    );
  }
}
