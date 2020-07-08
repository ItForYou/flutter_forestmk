import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutterforestmk/border/comment_item.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class comment_reply extends StatefulWidget {
  String wr_comment, wr_parent,writer_id;
  comment_reply({Key key, this.wr_comment,this.wr_parent, this.writer_id}) : super(key: key);

  @override
  _comment_replyState createState() => _comment_replyState();
}

class _comment_replyState extends State<comment_reply> {
  String real_mbid;
  List <Widget> items = [Container()];
  TextEditingController input_content = TextEditingController();
  var comment_data;

  void show_deletecmmt(id) {

    showDialog(
      context: context,
      builder: (BuildContext context2) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context2).size.height*0.03,
            child: Text("이 댓글을 삭제를 하시겠습니가?"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: ()async{
                final response = await http.post(
                    Uri.encodeFull('http://14.48.175.177/delete_comment.php'),
                    body: {
                      "wr_id":id,
                    },
                    headers: {'Accept' : 'application/json'}
                );
                if(response.statusCode ==200){
                  Navigator.pop(context2);
                  get_data();
                }
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

  Future<dynamic> update_comment_reply() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_comment_reply.php'),
        body: {
          "wr_id":widget.wr_parent,
          "wr_comment":widget.wr_comment,
          "comment_content":input_content.text,
          "mb_id":real_mbid,
        },
        headers: {'Accept' : 'application/json'}
    );

    if(response.statusCode==200){
      get_data();
    }

  }

  void add_items(){

     if(comment_data!=null);
      items.clear();

      for(int i=0; i<comment_data.length; i++) {
        //var before_tdata =null;
        var temp_data  = comment_item.fromJson(comment_data[i]);

//        if(i!=0)
//          before_tdata  = comment_item.fromJson(comment_data[i-1]);
//        else
//          before_tdata  = comment_item.fromJson(comment_data[comment_data.length-1]);

        String temp_wrcontent = temp_data.wr_content.replaceAll('\n','              ');
        //print(temp_wrcontent.length/24.2);
        double comment_height = (temp_wrcontent.length/24.2) * MediaQuery.of(context).size.height*0.00004;
        //print(comment_height);

        Widget temp = Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height * (0.085+comment_height)+13,
          margin: EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * 0.01),
          padding: EdgeInsets.only(left:
          //(temp_data.wr_comment != before_tdata.wr_comment)||(i==0)?
          i==0?
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
                  widget.writer_id == temp_data.mb_id?
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
                      .width * 0.03),),
                  (temp_data.mb_id==real_mbid) || (real_mbid=='admin')?
                  SizedBox(width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.02,):SizedBox(),
                  (temp_data.mb_id==real_mbid) || (real_mbid=='admin')?
                  Text("수정", style: TextStyle(color: Color(0xffdddddd),fontSize:MediaQuery.of(context).size.height * 0.02),):SizedBox(),
                  (temp_data.mb_id==real_mbid) || (real_mbid=='admin')?
                  SizedBox(width: MediaQuery
                       .of(context)
                      .size
                      .width * 0.02,):SizedBox(),
                  (temp_data.mb_id==real_mbid) || (real_mbid=='admin')?
                  InkWell(
                    child: Text("삭제", style: TextStyle(color: Color(0xffdddddd),fontSize:MediaQuery.of(context).size.height * 0.02),
                    ),
                    onTap: (){
                      show_deletecmmt(temp_data.wr_id);
                    },
                  ):SizedBox(),


                ],
              )
            ],
          ),
        );
        items.add(temp);
      }
}
  Future<dynamic> get_data() async{
  print(widget.wr_parent);
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_comments_reply.php'),
        body: {
          "wr_id":widget.wr_parent,
          "wr_comment":widget.wr_comment
        },
        headers: {'Accept' : 'application/json'}
    );
    if(response.statusCode==200){
      //print(response.body);
      setState(() {
        comment_data = jsonDecode(response.body);
        add_items();
      });
    }
  }

  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      if(sp.getString('id')!=null) {
        real_mbid = sp.getString('id');
      }
      else
        real_mbid='';
    });
  }

  Future<dynamic> update_reply() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_comment_reply.php'),
        body: {
          "wr_parent":widget.wr_parent,
          "wr_comment":widget.wr_comment,
          "comment_content":input_content.text,
          "mb_id":real_mbid,
        },
        headers: {'Accept' : 'application/json'}
    );

    if(response.statusCode==200){
      //print(response.body);
      get_data();
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_myinfo();
    get_data();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,'reply');
      },
      child: Scaffold(
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
              Navigator.pop(context,'reply');
            },
          ),
        ),
        body:
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
                child: Column(
                children: <Widget>[
                 Container(
                   width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height*0.82,
                   child: ListView(
                          children: <Widget>[
                            Column(
                              children: items,
                            )
                          ],
                      ),
                 ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.06,
                    child: TextFormField(
                        controller: input_content,
                        cursorColor: Colors.forestmk,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                          hintText: "댓글을 입력해주세요",
                          border: null,
                          enabledBorder:OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                          ),
                          suffixIcon:  InkWell(
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.2,
                              height: MediaQuery.of(context).size.height*0.05,
                              decoration: BoxDecoration(
                                color: Color(0xfff0f0f0),
                                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                              ),
                              child: Center(child: Text("작성")),
                            ),
                            onTap: (){
                              update_reply();
                              input_content.text ="";
                            },
                          )
                        )
                    ),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
