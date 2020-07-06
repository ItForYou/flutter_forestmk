import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterforestmk/chat_webview.dart';
import 'package:flutterforestmk/border/comment_reply.dart';
import 'package:flutterforestmk/image_detail.dart';
import 'package:flutterforestmk/member/loginpage.dart';
import 'package:flutterforestmk/border/view_item.dart';
import 'package:flutterforestmk/border/write_normal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterforestmk/border/comment_item.dart';

class Viewpage_mine extends StatefulWidget {
  String wr_id,mb_id;
  Viewpage_mine({Key key, this.wr_id, this.mb_id}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _ViewpagemineState createState() => _ViewpagemineState();
}

class _ViewpagemineState extends State<Viewpage_mine>{

  var itemdata,itemdata_now,comment_data;
  double itmes_height=0,itmes_height2=0;
  List <Widget> list_subitem = [Container()];
  List <Widget> list_extraitem = [Container()];
  List <Widget> widget_comments = [
    Container(
        height: 100,
        child:Center(
          child:Text("등록된 댓글이 없습니다."),
        )
    )
  ];
  String wr_id, mb_id='test',ca_name,real_mbid,price="", real_mbpwd, now_price="",seleted_comm_wrid='',uploadcomm_bt_txt="댓글게시";
  Widget Swiper_widget=SizedBox();
  String txt_soldout = "완료하기",declare_cate="사기신고";
  Color color_soldout = Color(0xff515151);
  int flg_soldout=0, flg_likenow=0, count_like=0,flg_opencomments=0,flg_uploadcomm_bt=0;
  bool got_item_now =false;
  TextEditingController delare_content = TextEditingController();
  TextEditingController input_comment = TextEditingController();
  ScrollController change_scroll = ScrollController(initialScrollOffset: 0);
  double content_size=0;

  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      if(sp.getString('id')!=null) {
        real_mbid = sp.getString('id');
        real_mbpwd = sp.getString('pwd');
        update_hitnrecent();
      }
      else
        real_mbid='';
    });
  }

  void show_soldout() {
    String temp_title = "";
    if(flg_soldout ==1){
      temp_title = "거래완료를 취소 하시겠습니가?";
    }
    else{
      temp_title = "거래를 완료 하시겠습니가?";
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.02,
            child: Text(temp_title),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: (){
                print(flg_soldout);
                if(flg_soldout ==1)
                  update_soldout(1);
                else
                  update_soldout(2);
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

  void add_widget_comments(){
    widget_comments.clear();

    for(int i=0; i<comment_data.length;i++) {

      var before_tdata =null;
      var temp_data  = comment_item.fromJson(comment_data[i]);

      if(i!=0)
        before_tdata  = comment_item.fromJson(comment_data[i-1]);
      else
        before_tdata  = comment_item.fromJson(comment_data[comment_data.length-1]);

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
                (temp_data.mb_id == widget.mb_id)?
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
                SizedBox(width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.02,),
                InkWell(
                  child: Text("댓글달기", style: TextStyle(color: Color(0xffdddddd), fontSize: MediaQuery
                      .of(context)
                      .size
                      .height * 0.015),),
                  onTap: ()async{
                    var result = await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => comment_reply(wr_comment: temp_data.wr_comment,wr_parent:temp_data.wr_parent, writer_id: widget.mb_id,)
                    ));
                    if(result == 'reply'){
                      get_comment();
                    }
                  },
                ),
                (temp_data.mb_id==real_mbid) || (real_mbid=='admin')?
                SizedBox(width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.02,):SizedBox(),
                (temp_data.mb_id==real_mbid) || (real_mbid=='admin')?
                InkWell(
                  child: Text("수정", style: TextStyle(color: Color(0xffdddddd),fontSize:MediaQuery.of(context).size.height * 0.02),),
                  onTap: (){
                    setState(() {
                      seleted_comm_wrid = temp_data.wr_id;
                      input_comment.text=temp_data.wr_content;
                      uploadcomm_bt_txt="수정하기";
                      flg_uploadcomm_bt = 1;
//                        change_scroll.animateTo(change_scroll.position.maxScrollExtent-MediaQuery.of(context).size.height * 0.45,duration: Duration(milliseconds: 300),curve: Curves.easeOutCirc);
                      change_scroll.jumpTo(change_scroll.position.maxScrollExtent);
                    });
                  },
                ):SizedBox(),
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
      widget_comments.add(temp);
    }
  }

  Future<dynamic> update_soldout(flg) async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_soldout.php'),
        body: {
          "wr_id":widget.wr_id==null?'':widget.wr_id,
          "flg" :flg.toString()
        },
        headers: {'Accept' : 'application/json'}
    );
    if(response.statusCode==200){
      Navigator.pop(context);
    }

    setState(() {

      if(flg==1) {
        flg_soldout =0;
        color_soldout = Color(0xff515151);
        txt_soldout = "완료하기";
      }
      else{
        flg_soldout=1;
        color_soldout = Color(0xffbebebe);
        txt_soldout = "거래완료";
      }
    });
  }

  Future<dynamic> update_like() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_like.php'),
        body: {
          "wr_id":widget.wr_id,
          "mb_id":real_mbid,
        },
        headers: {'Accept' : 'application/json'}
    );
    if(response.statusCode==200){
      setState(() {
        if(flg_likenow==0) {
          flg_likenow = 1;
          count_like ++;
        }
        else {
          count_like --;
          flg_likenow = 0;
        }
      });
    }
  }

  Future<dynamic> update_declare(popcontext) async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_declare.php'),
        body: {
          "ca_name":declare_cate==null?'':declare_cate,
          "wr_content":delare_content.text,
          "bo_table":'deal',
          "wr_id":widget.wr_id,
          "mb_id":real_mbid,
        },
        headers: {'Accept' : 'application/json'}
    );
    if(response.statusCode==200){
      Navigator.pop(popcontext);
    }

  }

  Future<dynamic> update_comment() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_comment.php'),
        body: {
          "wr_id":flg_uploadcomm_bt==0?widget.wr_id:seleted_comm_wrid,
          "comment_content":input_comment.text,
          "ca_name":itemdata_now!=null?itemdata_now['ca_name']:'',
          "mb_id":real_mbid,
          "w":flg_uploadcomm_bt==1?'u':''
        },
        headers: {'Accept' : 'application/json'}
    );
    if(response.statusCode==200){
      // print(response.body);
      get_comment();
    }
  }

  Future<dynamic> get_comment() async{
/*
    if(got_item_now ==false){
      get_comment();
      return;
    }*/
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_comments.php'),
        body: {
          "wr_id":widget.wr_id,
        },
        headers: {'Accept' : 'application/json'}
    );
    if(response.statusCode==200){
      //print(response.body);
      setState(() {
        comment_data = jsonDecode(response.body);
        add_widget_comments();
      });
    }
  }

  void show_deletecmmt(id) {

    showDialog(
      context: context,
      builder: (BuildContext context2) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context2).size.height*0.02,
            child: Text("이 댓글을 삭제를 하시겠습니까?"),
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
                  get_comment();
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

  void show_pushupwr(id) async{
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context2).size.height*0.032,
            child: Text("글을 맨 위로 업데이트 하시겠습니까?"),
          ),
          actions: <Widget>[

            new FlatButton(
              child: new Text("취소",style:TextStyle(color:Colors.red)),
              onPressed: () {
                Navigator.pop(context2);
              },
            ),
            new FlatButton(
              child: new Text("확인"),
              onPressed: ()async{
                final response = await http.post(
                    Uri.encodeFull('http://14.48.175.177/update_wrdatetime.php'),
                    body: {
                      "wr_id":widget.wr_id,
                    },
                    headers: {'Accept' : 'application/json'}
                );
                if(response.statusCode ==200){
                  Navigator.pop(context2);
                  Navigator.pop(context,"delete");
                }
              },
            ),
          ],
        );
      },
    );
  }

  void show_declare() {

    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        // return object of type Dialog
        return StatefulBuilder(
            builder:(context, setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(MediaQuery
                        .of(context)
                        .size
                        .width * 0.02))
                ),
                title: null,
                content: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.55,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.07,
                          padding: EdgeInsets.only(right: MediaQuery
                              .of(context)
                              .size
                              .width * 0.02, left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.02),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                  width: 1, color: Color(0xffdddddd)))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("신고하기"),
                              Icon(Icons.clear, color: Color(0xffdddddd),),
                            ],
                          ),
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    width: 1, color: Color(0xffdddddd)))
                            ),
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: "사기신고",
                                  groupValue: declare_cate,
                                  activeColor: Colors.forestmk,
                                  onChanged: (T) {
                                    setState(() {
                                      declare_cate = T;
                                    });
                                  },
                                ),
                                Text("사기신고")
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              declare_cate = '사기신고';
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    width: 1, color: Color(0xffdddddd)))
                            ),
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: "성희롱, 욕설 등",
                                  groupValue: declare_cate,
                                  activeColor: Colors.forestmk,
                                  onChanged: (T) {
                                    setState(() {
                                      declare_cate = T;
                                    });
                                  },
                                ),
                                Text("성희롱, 욕설 등")
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              declare_cate = '성희롱, 욕설 등';
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    width: 1, color: Color(0xffdddddd)))
                            ),
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: "선정적인 게시물",
                                  groupValue: declare_cate,
                                  activeColor: Colors.forestmk,
                                  onChanged: (T) {
                                    setState(() {
                                      declare_cate = T;
                                    });
                                  },
                                ),
                                Text("선정적인 게시물")
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              declare_cate = '선정적인 게시물';
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    width: 1, color: Color(0xffdddddd)))
                            ),
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: "판매금지 품목",
                                  groupValue: declare_cate,
                                  activeColor: Colors.forestmk,
                                  onChanged: (T) {
                                    setState(() {
                                      declare_cate = T;
                                    });
                                  },
                                ),
                                Text("판매금지 품목")
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              declare_cate = '판매금지 품목';
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    width: 1, color: Color(0xffdddddd)))
                            ),
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: "복사 중복 도배",
                                  groupValue: declare_cate,
                                  activeColor: Colors.forestmk,
                                  onChanged: (T) {
                                    setState(() {
                                      declare_cate = T;
                                    });
                                  },
                                ),
                                Text("복사 중복 도배")
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              declare_cate = '복사 중복 도배';
                            });
                          },
                        ),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.04,
                          margin: EdgeInsets.only(top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.01, left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.025),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: itemdata_now['mb_name'],
                                        style: TextStyle(
                                            color: Colors.forestmk, fontSize: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.04)),
                                    TextSpan(text: "님을 신고합니다.", style: TextStyle(
                                        color: Colors.black, fontSize: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.03)),
                                  ]
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.1,
                            margin: EdgeInsets.only(left: MediaQuery
                                .of(context)
                                .size
                                .width * 0.03, right: MediaQuery
                                .of(context)
                                .size
                                .width * 0.03,),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Color(0xffdddddd))
                            ),
                            child: TextFormField(
                              controller: delare_content,
                              maxLines: null,
                              decoration: InputDecoration(
                                  border: InputBorder.none
                              ),

                            )
                        ),
                        InkWell(
                          child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.06,
                              margin: EdgeInsets.only(top: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.02,),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Color(0xffdddddd)),
                                  color: Color(0xff333333)
                              ),
                              child: Center(child: Text(
                                "신고하기", style: TextStyle(color: Colors.white),))

                          ),
                          onTap: (){
                            update_declare(context);
                          },
                        ),


                      ],
                    ),
                  ),
                ),

                actions: null,
              );
            }
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(MediaQuery
                  .of(context)
                  .size
                  .width * 0.02))
          ),
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

  void show_block() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(MediaQuery
                    .of(context)
                    .size
                    .width * 0.02))
            ),
            contentPadding: EdgeInsets.all(0),
            title:null,
            content: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.15,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.075,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1, color: Color(0xffdddddd)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width*0.1,
                                height: MediaQuery.of(context).size.width*0.1,
                                margin: EdgeInsets.only(
                                    left:  MediaQuery.of(context).size.width*0.05,
                                    top: MediaQuery.of(context).size.height*0.005,
                                    bottom: MediaQuery.of(context).size.height*0.005),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    color: Color(0xfff3f3f3),
                                    image: DecorationImage(//이미지 꾸미기
                                      fit:BoxFit.cover,
                                      image:itemdata_now['mb_1']!=''?NetworkImage(itemdata_now['mb_1']):AssetImage("images/wing_mb_noimg2.png"),//이미지 가져오기
                                    )
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                              Text(itemdata_now['mb_name']),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  right:  MediaQuery.of(context).size.width*0.05),
                              child: InkWell(
                                child: Icon(Icons.clear,color: Color(0xffdddddd)),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              )
                          ),

                        ],
                      ),
                    ),
                    InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.075,
                        padding: EdgeInsets.only(    left:  MediaQuery.of(context).size.width*0.05,),
                        child: Align(alignment: Alignment.centerLeft,child: Text("선택한 회원 차단하기")),
                      ),
                      onTap: (){
                        if(real_mbid == itemdata_now['mb_id'])
                          show_Alert("본인을 차단 할 수 없습니다.", 1);
                        else
                          update_block(context);
                      },
                    )
                  ],
                )
            ),
            actions: null
        );
      },
    );
  }

  Future<dynamic> update_block(popcontext) async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_block.php'),
        body: {
          "block_id":itemdata_now['mb_id'],
          "mb_id":real_mbid,
          "flg":1.toString()
        },
        headers: {'Accept' : 'application/json'}
    );
    if(response.statusCode==200){
      Navigator.pop(popcontext);
      show_Alert("선택한 회원이 차단되었습니다.", 1);
    }
  }

  Future<dynamic> update_hitnrecent() async{


    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_hitnrecent.php'),
        body: {
          "wr_id":widget.wr_id,
          "mb_id":real_mbid,
          "bo_table":'deal'
        },
        headers: {'Accept' : 'application/json'}
    );

    if(response.statusCode==200){
    }

  }


  Widget get_content2(id,flg){

    var temp_data;
    String temp_price;
    if(flg==1) {
      temp_data = view_item.fromJson(itemdata['data'][id]);
    }
    else
      temp_data = view_item.fromJson(itemdata['data2'][id]);



    if(temp_data.ca_name =='업체'){
      price=temp_data.wr_subject;
    }
    else if(temp_data.wr_1 =='무료나눔'){
      price=temp_data.wr_1;
    }
    else{
      MoneyFormatterOutput  fmf = FlutterMoneyFormatter(amount: double.parse(temp_data.wr_1)).output;
      price='금액 ' + fmf.withoutFractionDigits.toString()+'원';
    }

    InkWell temp = InkWell(
      child: Container(
        height: MediaQuery.of(context).size.height*0.25,
        width: MediaQuery.of(context).size.width*0.45,
        decoration: BoxDecoration(color: Colors.white),

        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*0.4,
                      height:  MediaQuery.of(context).size.height*0.15,
                      child:temp_data.file==''?Image.asset("images/noimg.jpg"):Image.network(temp_data.file, fit: BoxFit.fitWidth,),
                    ),

                    SizedBox(height: 5,),
                    Text(temp_data.wr_subject, style: TextStyle(fontSize: 12),),
                    SizedBox(height: 5,),
                    Text(price, style: TextStyle(fontSize: 15),),
                  ]
              ),
            ],
          )
          ,
        ),
      ),

      onTap: ()async{
        print(temp_data.mb_id);
        var result = await Navigator.push(context, MaterialPageRoute(
            builder: (context) => Viewpage_mine(wr_id:temp_data.wr_id, mb_id:temp_data.mb_id)
        ));
        if(result == 'delete' || result=='refresh'){
          get_data();
        }
//        Navigator.push(context,MaterialPageRoute(
//            builder:(context) => Viewpage_mine(wr_id:temp_data.wr_id)
//        ));
      },
    );
    return temp;
  }

  Future<dynamic> get_lkeflg() async{
    if(real_mbid!=null && real_mbid!='') {
      final response = await http.post(
          Uri.encodeFull('http://14.48.175.177/get_likeflg.php'),
          body: {
            "wr_id": widget.wr_id,
            "mb_id": real_mbid,
          },
          headers: {'Accept': 'application/json'}
      );

      var temp = jsonDecode(response.body);
      setState(() {
        flg_likenow = int.parse(temp['cnt']);
      });
    }
  }

  void move_imgdetail(int index){
    List <dynamic> list=[];
    if(itemdata_now!=null && itemdata_now['files'].length>0){
        for(int i=0; i<itemdata_now['files'].length; i++){

          String temp_str = itemdata_now['files'][i];

          list.add(temp_str);

        }
        if(list.length==itemdata_now['files'].length) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => image_detail(info: list,flg_view: 2,)
          ));
        }
    }
  }

  Future<dynamic> get_data_now() async{
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_viewwr.php'),
        body: {
          "wr_id" :widget.wr_id,
        },
        headers: {'Accept' : 'application/json'}
    );
    if(response.statusCode ==200) {
      setState(() {
        got_item_now = true;
        itemdata_now = jsonDecode(response.body);

        if (itemdata_now['ca_name'] == '업체') {
          now_price = itemdata_now['wr_subject'];
        }
        else if (itemdata_now['wr_1'] == '무료나눔') {
          now_price = itemdata_now['wr_1'];
        }
        else {
          MoneyFormatterOutput fmf = FlutterMoneyFormatter(
              amount: double.parse(itemdata_now['wr_1'])).output;
          now_price = '금액 ' + fmf.withoutFractionDigits.toString() + '원';
        }
        mb_id = itemdata_now['mb_id'];
        ca_name = itemdata_now['ca_name'];
        count_like = int.parse(itemdata_now['wr_10']);
        if(itemdata_now['files'].length>0 && itemdata_now['files'][0]!='nullimage') {
          Swiper_widget = Container(
            height: MediaQuery.of(context).size.height*0.35,
            width: MediaQuery.of(context).size.width,
            child: Swiper(
              itemCount: itemdata_now['files'].length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.35,
                  decoration: BoxDecoration(
                      color: Color(0xfff3f3f3),
                      image: DecorationImage( //이미지 꾸미기
                        fit: BoxFit.cover,
                        image: itemdata_now['files'][index] != '' ? NetworkImage(
                            itemdata_now['files'][index]) : AssetImage(
                            "images/wing_mb_noimg2.png"), //이미지 가져오기
                      )
                  ),
                );
                //Image.network(itemdata_now['files'][index]);
              },
              pagination: (itemdata_now['files'].length) > 1
                  ? SwiperPagination()
                  : null,
              loop: (itemdata_now['files'].length) > 1 ? true : false,
              onTap: move_imgdetail,
            ),
          );
        }
        get_lkeflg();
        get_data();
      });
    }
  }

  void show_delete() {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context2).size.height*0.06,
            child: Text("한번 삭제한 자료는 복구할 방법이 없습니다.\n정말 삭제하시겠습니까?"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: ()async{
                final response = await http.post(
                    Uri.encodeFull('http://14.48.175.177/delete_wr.php'),
                    body: {
                      "bo_table" :"deal",
                      "wr_id":widget.wr_id,
                    },
                    headers: {'Accept' : 'application/json'}
                );
                if(response.statusCode ==200){
                  Navigator.pop(context2);
                  Navigator.pop(context,"delete");
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


  Future<dynamic> get_data() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_view.php'),
        body: {
          "wr_id" :widget.wr_id,
          "mb_id":mb_id,
          "ca_name":ca_name,
        },
        headers: {'Accept' : 'application/json'}
    );
    setState(() {
      itemdata = jsonDecode(response.body);
      set_items();
    });
  }

  void set_items(){

    if(itemdata['data'].length > 0) {
      itmes_height = MediaQuery.of(context).size.height*0.355;
      list_subitem.clear();
      for (var i = 0; i < itemdata['data'].length; i++) {
        list_subitem.add(get_content2(i,1));
      }
    }

    if(itemdata['data2'].length > 0) {
      itmes_height2 = MediaQuery.of(context).size.height*0.35;
      list_extraitem.clear();
      for (var i = 0; i < itemdata['data2'].length; i++) {
        list_extraitem.add(get_content2(i,2));
      }
    }

  }

  void show_ban() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.02,
            child: Text("자신의 글입니다."),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void request_logindialog(){

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.03))

            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.03,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("로그인이 필요합니다.", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),)
                ],
              ),
            ),
            actions:  <Widget>[
              new FlatButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(
                      builder:(context) => loginpage()
                  ));
                },
              ),
            ]
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_myinfo();
    get_data_now();
    get_comment();
  }


  @override
  Widget build(BuildContext context) {

    if(itemdata!=null) {

      if (itemdata_now['wr_content'] != '' &&
          itemdata_now['wr_content'] != null) {
        content_size = MediaQuery
            .of(context)
            .size
            .height * (itemdata_now['wr_content'].length / 850);
      }

    }

    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,'refresh');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(now_price ,style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            leading: InkWell(

              child:Padding(
                  padding: EdgeInsets.all(13),
                  child:Image.asset("images/hd_back.png")
              ),
              onTap: (){
                Navigator.of(context).pop(true);
              },
            ),
            actions : <Widget>[
              RaisedButton(
                color: Color(0xfffae100),
                onPressed: ()async{
                  if(itemdata_now!=null) {
                    if (mb_id != null && real_mbid != null && real_mbid != '' &&
                        real_mbid != mb_id) {
                      var result = await Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) =>
                              chat_webview(
                                url: "http://14.48.175.177/bbs/login_check.php?mb_id=" +
                                    real_mbid + "&mb_password=" +
                                    real_mbpwd + "&flg_view=1&view_id=" +
                                    widget.wr_id + "-" + real_mbid, view: 1,

                              )
                      ));
                      if (result == 'change') {
                        get_data();
                      }
                    }
                    else if (real_mbid == itemdata_now['mb_id']) {
                      show_ban();
                    }
                    else {
                      request_logindialog();
                    }
                  }
                },
                child: Text("1:1채팅"),
                textColor: Colors.black,
              )
            ]
        ),
        body:
        ListView(
          controller: change_scroll,
          children: <Widget>[
            Swiper_widget,
            Container(
              height: MediaQuery.of(context).size.height*0.1,
              padding:EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Row(
                      children: <Widget>[
                         Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                border: Border.all(color: Color(0xffcccccc)),
                                image: DecorationImage(//이미지 꾸미기
                                    fit:BoxFit.cover,
                                  image:(itemdata_now!=null)&&(itemdata_now['mb_1']!='')?NetworkImage(itemdata_now['mb_1']):AssetImage("images/wing_mb_noimg2.png"),//이미지 가져오기
                                )
                            ),
                        ),
                        SizedBox(width: 3,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(itemdata_now==null?"테스트":itemdata_now['mb_name'],style: TextStyle(fontSize: 16, fontWeight:  FontWeight.bold),),
                            SizedBox(height: 8,),
                            Text(itemdata_now==null?"테스트":itemdata_now['ca_name']=='업체'?itemdata_now['wr_11']:itemdata_now['mb_2'],style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                onTap: (){
                  if(real_mbid!='')
                    show_block();
                  else{
                    request_logindialog();
                  }
                }
                  ),
                  itemdata_now!=null?
                  Row(
                    children: <Widget>[
                      (itemdata_now['mb_id']==real_mbid || real_mbid =='admin' || real_mbid=='lets080')&&(itemdata_now['ca_name']!='업체')?
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.17,
                          height: MediaQuery.of(context).size.height*0.06,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(23)),
                              border: Border.all(color: Color(0xffcccccc)),
                              color: color_soldout
                          ),
                          child: Column(
                            children: <Widget>[
                              Image.asset("images/write_icon01.png",   width: MediaQuery.of(context).size.width*0.08, height: MediaQuery.of(context).size.height*0.027,),
                              Text(txt_soldout,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.025,color: Colors.white),)
                            ],
                          ),
                        ),
                        onTap: (){
                            show_soldout();
                        },
                      ):Container(),
                      (itemdata_now['ca_name']=='업체') && (itemdata_now['mb_id'] == real_mbid || real_mbid =='admin' || real_mbid =='lets080')?
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.16,
                          height: MediaQuery.of(context).size.height*0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.1)),
                              border: Border.all(color: Color(0xffcccccc)),
                              color: color_soldout
                          ),
                          child: Column(
                            children: <Widget>[
                              Image.asset("images/gotop.png",   width: MediaQuery.of(context).size.width*0.12, height: MediaQuery.of(context).size.height*0.035,),
                              Text('글맨위로',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.028,color: Colors.white),)
                            ],
                          ),
                        ),
                        onTap: (){
                          show_pushupwr(itemdata_now['wr_id']);
                        },
                      ):Container(),

                      SizedBox(width: 3,),
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.17,
                          height: MediaQuery.of(context).size.height*0.06,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(23)),
                              border: Border.all(color: Color(0xffcccccc)),
//                              image: DecorationImage(//이미지 꾸미기
//                                  fit:BoxFit.cover,
//                                  image:NetworkImage("http://forestmk.itforone.co.kr/data/member/3542386191_O4hMBHJf_d1f767e86e735db50a43847faef0544e41ede2ed.jpg")//이미지 가져오기
//                              )
                              color: Color(0xff515151)
                          ),
                          child: Column(
                            children: <Widget>[
                              Image.asset("images/fa-siren-on.png",   width: MediaQuery.of(context).size.width*0.08, height: MediaQuery.of(context).size.height*0.027,),
                              Text("신고하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.025,color: Colors.white))
                            ],
                          ),
                        ),
                        onTap: (){
                          if(real_mbid!='')
                            show_declare();
                          else {
                            request_logindialog();
                          }
                        },
                      ),
                    ],
                  ):Container(),
                ],
              ),
            ),
            (itemdata_now!=null)&&(itemdata_now['ca_name']=='업체')?
            Container(
                padding: EdgeInsets.only(left: 15,),
                width: MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height*0.02,
                child:Text(itemdata_now.wr_5)
            ):Container(),
            Container(
              padding: EdgeInsets.only(left: 15,right: 15,top: 10, bottom: 10),
              height: MediaQuery.of(context).size.height*0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(itemdata_now==null?'테스트':itemdata_now['wr_subject'],style:TextStyle(fontSize: MediaQuery.of(context).size.height*0.023),),
                      SizedBox(height: 10,),
                      Row(
                          children:<Widget>[
                            Text(itemdata_now==null?'테스트':itemdata_now['timegap'],style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.013),),
                            SizedBox(width: 2,),
                            Text(itemdata_now==null?'테스트':itemdata_now['ca_name'],style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.013),),
                          ]
                      )


                    ],
                  ),
                  real_mbid==mb_id?
                  Row(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color:Color(0xffdddddd)),
                              color: Color(0xffffffff),
                            ),
                            width: 35,
                            height: 35,
                            child: Center(child:Text("수정", style: TextStyle(),),)
                        ),
                        onTap: ()async{

                          var result = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => write_normal(wr_id: widget.wr_id)
                          ));
                          if(result == 'success'){
                            Navigator.pop(context,"delete");
                          }
                        },
                      ),
                      SizedBox(width: 3,),
                      InkWell(
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color:Color(0xffdddddd)),
                              color: Color(0xffffffff),
                            ),
                            width: 35,
                            height: 35,
                            child: Center(child:Text("삭제", style: TextStyle(),),)
                        ),
                        onTap: (){
                          show_delete();
                        },
                      ),
                    ],
                  ):Container(),
                ],
              ),
            ),
            Container(
              child: Wrap(children : [
                Text(itemdata_now==null?'테스트':itemdata_now['wr_content'])
              ]),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.05,
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Text("좋아요",style: TextStyle(fontSize: 11),),
                  SizedBox(width: 3,),
                  Text(count_like.toString()),
                  SizedBox(width: 3,),
                  Text("댓글",style: TextStyle(fontSize: 11),),
                  Text(itemdata_now==null?'0':itemdata_now['comments']),
                  SizedBox(width: 3,),
                  Text("조회수",style: TextStyle(fontSize: 11),),
                  SizedBox(width: 3,),
                  Text(itemdata_now==null?'0':itemdata_now['wr_hit']),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              height: MediaQuery.of(context).size.height*0.07,
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(width: 1,color: Color(0xffefefef)), bottom: BorderSide(width: 1,color: Color(0xffefefef)),)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Row(
                      children: <Widget>[

                        Container(
                            width:MediaQuery.of(context).size.width*0.05,
                            child: Image.asset("images/fa-heart.png")
                        ),
                        Text("좋아요",style: TextStyle(color: flg_likenow==0?Colors.black:Colors.forestmk),),

                      ],
                    ),
                    onTap: (){
                      if(real_mbid=='')
                        request_logindialog();
                      else
                        update_like();
                    },
                  ),
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Container(
                            width:MediaQuery.of(context).size.width*0.05,
                            child: Image.asset("images/fa-comment-alt.png")
                        ),
                        Text("댓글 달기",style: TextStyle(color: flg_opencomments==0?Colors.black:Colors.forestmk),),
                      ],
                    ),
                    onTap: (){
                      if(real_mbid!='') {
                        setState(() {
                          if (flg_opencomments == 0) {
                            setState(() {
                              flg_opencomments = 1;
                            });
                          }
                          else {
                            setState(() {
                              flg_opencomments = 0;
                            });
                          }
                        });
                      }
                      else{
                        request_logindialog();
                      }
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          width:MediaQuery.of(context).size.width*0.05,
                          child: Image.asset("images/fa-share.png")
                      ),
                      Text("공유하기"),
                    ],
                  ),

                ],
              ),
            ),

            (flg_opencomments==1) && (real_mbid!='')?
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.05,
              child: Row(
                children: <Widget>[

                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.06,
                      height: MediaQuery
                          .of(context)
                          .size
                          .width * 0.06,
                      margin: EdgeInsets.only(left: MediaQuery
                          .of(context)
                          .size
                          .width * 0.03,),
                      child: Image.asset("images/fa-comment-alt.png")
                  ),
                  SizedBox(width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.02,),
                  Text("댓글")
                ],
              ),
            ):SizedBox(),
            (flg_opencomments==1) && (real_mbid!='')?
            Column(
              children: widget_comments,
            ):SizedBox(),
            (flg_opencomments==1) && (real_mbid!='')?
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.16,
              margin: EdgeInsets.all(MediaQuery
                  .of(context)
                  .size
                  .width * 0.05,),
              padding: EdgeInsets.all(MediaQuery
                  .of(context)
                  .size
                  .width * 0.02,),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xffdddddd))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "댓글을 입력하세요",
                        hintStyle: TextStyle(color: Color(0xffdddddd),fontSize:MediaQuery
                            .of(context)
                            .size
                            .height * 0.02 )
                    ),
                    maxLines: 2,
                    controller: input_comment,
                  ),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          flg_uploadcomm_bt==1?
                          InkWell(
                              child: Text(
                                "수정취소", style: TextStyle(color: Colors.forestmk),
                                textAlign: TextAlign.right,),
                              onTap: (){
                                setState((){
                                  seleted_comm_wrid='';
                                  flg_uploadcomm_bt=0;
                                  uploadcomm_bt_txt="등록하기";
                                  input_comment.text ='';
                                });
                              }
                          ):SizedBox(),
                          SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                          InkWell(
                              child: Text(
                                uploadcomm_bt_txt, style: TextStyle(color: Colors.forestmk),
                                textAlign: TextAlign.right,),
                              onTap: (){
                                if(real_mbid!=''){
                                  update_comment();
                                  flg_uploadcomm_bt=0;
                                  uploadcomm_bt_txt="댓글게시";
                                  seleted_comm_wrid='';
                                  input_comment.text = '';
                                }
                              }
                          ),
                        ],
                      )
                  ),

                ],
              ),

            ):SizedBox(),


            Container(
              height: itmes_height,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1,color: Color(0xffefefef)))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height*0.1,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: MediaQuery.of(context).size.height*0.03,),
                    child: Text(itemdata_now==null?"테스트":itemdata_now['mb_name']+"님의 판매상품",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.25,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.055,),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: list_subitem,
                    ),
                  ),

                ],
              ),
            ),
            Container(
              height: itmes_height2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height*0.1,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: MediaQuery.of(context).size.height*0.03,),
                    child: Text("관련상품",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.25,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.055,),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: list_extraitem,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
