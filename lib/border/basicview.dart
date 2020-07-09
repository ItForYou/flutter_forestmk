import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterforestmk/border/basic_item.dart';
import 'package:flutterforestmk/border/write_basic.dart';
import 'package:flutterforestmk/border/comment_item.dart';
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
  List <Widget> widget_comments = [Center(child:Text("등록된 댓글이 없습니다."))];
  TextEditingController input_comment = TextEditingController();
  var comment_data;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.055,
            child: Text("한번 삭제한 자료는 복구할 방법이 없습니다.\n정말 삭제하시겠습니까?"),
          ),
          actions: <Widget>[
         
            new FlatButton(
              child: new Text("취소",style: TextStyle(color:Colors.red),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("확인"),
              onPressed: (){
                delete_data(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> delete_data(popcontext) async{
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/delete_wr.php'),
        body: {
          "wr_id":widget.item.wr_id!=null?widget.item.wr_id:'',
          "bo_table":widget.bo_table!=null?widget.bo_table:'',
        },
        headers: {'Accept' : 'application/json'}
    );

      if(response.statusCode==200){
        Navigator.pop(popcontext);
          Navigator.pop(context,"delete");
      }
  }

  Future<dynamic> update_comment() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_comment.php'),
        body: {

          "wr_id":widget.item.wr_id,
          "comment_content":input_comment.text,
          "ca_name":'',
          "bo_table" : 'qna',
          "mb_id":widget.mb_id,
          "w":''

        },
        headers: {'Accept' : 'application/json'}
    );

    if(response.statusCode==200){

      //print(response.body);
    }

  }

  Future<dynamic> get_comments() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_comments.php'),
        body: {
          "wr_id":widget.item.wr_id,
          "bo_table":'qna',
        },
        headers: {'Accept' : 'application/json'}
    );

    if(response.statusCode==200){

      //print(response.body);
      setState(() {
      //  print(response.body);
        comment_data = jsonDecode(response.body);
        add_widget_comments();
      });
    }
  }

  void add_widget_comments(){

    widget_comments.clear();

    for(int i=0; i<comment_data.length;i++) {

      var before_tdata =null;
      var temp_data  = comment_item.fromJson(comment_data[i]);

      if(i!=0)
        before_tdata  = comment_item.fromJson(comment_data[i-1]);
      else
        before_tdata  = comment_item.fromJson(comment_data[comment_data.length-1]);

      // String temp_wrcontent = temp_data.wr_content.replaceAll('\n','              ');
      //print(temp_wrcontent.length/24.2);
      // double comment_height = (temp_wrcontent.length/24.2) * MediaQuery.of(context).size.height*0.00004;
      //print(comment_height);

      Widget temp = Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * (0.085)+13,
        margin: EdgeInsets.only(bottom: MediaQuery
            .of(context)
            .size
            .height * 0.01),
        padding: EdgeInsets.only(left:
        (temp_data.wr_comment != before_tdata.wr_comment)||(i==0)?
        MediaQuery
            .of(context)
            .size
            .width * 0.05:
        MediaQuery
            .of(context)
            .size
            .width * 0.1,
          right: MediaQuery
              .of(context)
              .size
              .width * 0.05,),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1, color: Color(0xffdddddd)))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                (temp_data.mb_id == widget.item.mb_id)?
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.02,
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.02,
                  decoration: BoxDecoration(
                      color: Colors.forestmk,
                      borderRadius: BorderRadius.all(Radius.circular(MediaQuery
                          .of(context)
                          .size
                          .width * 0.05,))
                  ),
                ):SizedBox(width: 0,),
                SizedBox(width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.02,),
                Text(temp_data.mb_name==''?'':temp_data.mb_name, style: TextStyle(fontSize: MediaQuery
                    .of(context)
                    .size
                    .width * 0.032),)

              ],
            ),
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * 0.005,),
            Text(
                temp_data.wr_content==''?'':temp_data.wr_content,
                style: TextStyle(fontSize: MediaQuery
                    .of(context)
                    .size
                    .height * 0.016)),
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * 0.005,),
            Row(
              children: <Widget>[
                Text(temp_data.wr_datetime==''?'':temp_data.wr_datetime, style: TextStyle(
                    color: Color(0xffdddddd), fontSize: MediaQuery
                    .of(context)
                    .size
                    .height * 0.016),),
                SizedBox(width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.02,),
              ],
            )
          ],
        ),
      );
      widget_comments.add(temp);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    get_comments();
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
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.12,
                      height: MediaQuery.of(context).size.height*0.08,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Color(0xffd9d9d9))
                      ),
                      child: Center(child: Text("목록")),
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
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
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1, ),
              child: Wrap(children: <Widget>[
                Column(
                  children: widget_comments,
                )
              ],),
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
                        controller: input_comment,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none
                        ),
                    ),
                  ),
                  InkWell(
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text("댓글달기",style: TextStyle(color: Colors.forestmk),)
                      ),
                    onTap: (){
                        if(widget.mb_id!=null && widget.mb_id !='') {
                          update_comment();
                        }
                        else{

                        }
                    },
                  )
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
