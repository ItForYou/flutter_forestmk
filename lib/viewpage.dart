import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterforestmk/main_item.dart';
import 'package:flutterforestmk/view_item.dart';
import 'package:flutterforestmk/viewpage_mine.dart';
import 'package:flutterforestmk/write_normal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_swiper/flutter_swiper.dart';

class Viewpage extends StatefulWidget {
  final String tag,src;
  final main_item info;
  Viewpage({Key key, this.title, this.tag, this.src, this.info}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ViewpageState createState() => _ViewpageState();
}

class _ViewpageState extends State<Viewpage>{
  String price,real_mbid;
  var itemdata;
  List <dynamic> path =[];
  List <Widget> list_subitem = [Container()];
  List <Widget> list_extraitem = [Container()];
  Widget  hero_content= Container();
  double itmes_height=0,itmes_height2=0;
  int flg_soldout=0;
  String txt_soldout = "완료하기";
  Color color_soldout = Color(0xff515151);


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

  void show_declare() {
    String temp_title = "";
    if(flg_soldout==1){
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
                if(flg_soldout==1)
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

  Future<dynamic> update_soldout(flg) async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_soldout.php'),
        body: {
          "wr_id":widget.info.wr_id==null?'':widget.info.wr_id,
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


  Widget get_content2(id,flg){
    var temp_data;
    String temp_price;
    if(flg==1)
      temp_data = view_item.fromJson(itemdata['data'][id]);
    else
      temp_data = view_item.fromJson(itemdata['data2'][id]);

    if(temp_data.ca_name =='업체'){
      temp_price=temp_data.wr_subject;
    }
    else if(temp_data.wr_1 =='무료나눔'){
      temp_price=temp_data.wr_1;
    }
    else{
      temp_price='금액 '+temp_data.wr_1+'원';
    }

    //print(temp_data);

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
                        height: MediaQuery.of(context).size.height*0.15,
                        child:temp_data.file==''?Image.asset("images/noimg.jpg"):Image.network(temp_data.file, fit: BoxFit.fitWidth,),
                      ),

                        SizedBox(height: 5,),
                        Text(temp_data.wr_subject, style: TextStyle(fontSize: 12),),
                        SizedBox(height: 5,),
                        Text(temp_price, style: TextStyle(fontSize: 15),),
                    ]
              ),
            ],
          )
          ,
        ),
      ),
      onTap: ()async{
        var result = await Navigator.push(context, MaterialPageRoute(
            builder: (context) => Viewpage_mine(wr_id:temp_data.wr_id)
        ));
        if(result == 'delete'|| result=='refresh'){
          get_data();
        }
//        Navigator.push(context,MaterialPageRoute(
//            builder:(context) => Viewpage_mine(wr_id:temp_data.wr_id)
//        ));
      },
    );
    return temp;
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

  void set_herocontent(List <dynamic> path){
    if(path.length-1 > 0){

        hero_content = Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.33,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Swiper(
            itemCount: path.length-1,
            itemBuilder: (BuildContext context, int index){
              return Image.network(path[index+1]);
            },
            pagination: (path.length-1)>1?SwiperPagination():null,
            loop: (path.length-1)>1? true:false,
          ),
        );

    /*  hero_content = Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.33,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Swiper(
          itemCount: path.length,
          itemBuilder: (BuildContext context, int index){
            Image.network('http://14.48.175.177/data/file/deal/'+path[index]);
          },
          pagination: SwiperPagination(),
        ),
      );*/
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
                      "wr_id":widget.info.wr_id,
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
          "wr_id" :widget.info.wr_id,
          "mb_id":widget.info.mb_id,
          "ca_name":widget.info.ca_name,
        },
        headers: {'Accept' : 'application/json'}
    );
    setState(() {
      itemdata = jsonDecode(response.body);
      set_items();
    });

  }

  void set_items(){
  //print(itemdata['data'][0]);
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

@override
  void initState() {
    // TODO: implement initState
    load_myinfo();

    get_data();
    path= widget.info.file;

    if(widget.info.wr_9 =='거래완료') {
      setState(() {
        txt_soldout ="거래완료";
        color_soldout=Color(0xffbebebe);
        flg_soldout = 1;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    set_herocontent(path);
    if(widget.info.ca_name =='업체'){
      price=widget.info.wr_subject;
    }
    else if(widget.info.wr_1 =='무료나눔'){
      price=widget.info.wr_1;
    }
    else{
      price='금액 '+widget.info.wr_1+'원';
    }

    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,'delete');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
              title: Text( price,style: TextStyle(color: Colors.black),),
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
                  onPressed: (){},
                  child: Text("1:1채팅"),
                  textColor: Colors.black,
                )
            ]
            ),
        body:
            ListView(
              children: <Widget>[
                Hero(
                      tag: widget.tag,
                      child:hero_content
            ),
                Container(
                  height: MediaQuery.of(context).size.height*0.13,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Color(0xfff3f3f3),
                                image: DecorationImage(//이미지 꾸미기
                                    fit:BoxFit.cover,
                                    image:widget.info.profile_img!=''?NetworkImage(widget.info.profile_img):AssetImage("images/wing_mb_noimg2.png"),//이미지 가져오기
                                )
                            ),
                          ),
                          SizedBox(width: 3,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.info.mb_name==null?'test':widget.info.mb_name,style: TextStyle(fontSize: 16, fontWeight:  FontWeight.bold),),
                              SizedBox(height: 8,),
                              Text(widget.info.mb_2==null?'test':widget.info.mb_2,style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          widget.info.mb_id==real_mbid?
                          InkWell(
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.17,
                              height: MediaQuery.of(context).size.height*0.055,
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
                          SizedBox(width: 3,),
                          Container(
                            width: MediaQuery.of(context).size.width*0.17,
                            height: MediaQuery.of(context).size.height*0.055,
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
                        ],
                      ),
                    ],
                  ),
                ),
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
                          Text(widget.info.wr_subject==null?'teest':widget.info.wr_subject,style: TextStyle(fontSize: 20),),
                          SizedBox(height: 10,),
                          Row(
                            children:<Widget>[
                              Text(widget.info.timegap==null?'test':widget.info.timegap,style: TextStyle(fontSize: 10),),
                              SizedBox(width: 2,),
                              Text(widget.info.ca_name==null?'test':widget.info.ca_name,style: TextStyle(fontSize: 10),),
                            ]
                          )


                        ],
                      ),
                      real_mbid==widget.info.mb_id?
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
                                  builder: (context) => write_normal(info: widget.info)
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
                  height: MediaQuery.of(context).size.height*0.2,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.032),
                  child: Text(widget.info.wr_content==null?'test':widget.info.wr_content),

                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: <Widget>[
                      Text("좋아요",style: TextStyle(fontSize: 11),),
                      SizedBox(width: 3,),
                      Text(widget.info.like==null?'test':widget.info.like,),
                      SizedBox(width: 3,),
                      Text("댓글",style: TextStyle(fontSize: 11),),
                      Text(widget.info.comments==null?'test':widget.info.comments),
                      SizedBox(width: 3,),
                      Text("조회수",style: TextStyle(fontSize: 11),),
                      SizedBox(width: 3,),
                      Text(widget.info.wr_hit==null?'test':widget.info.wr_hit),
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
                        Row(
                          children: <Widget>[

                            Container(
                                width:MediaQuery.of(context).size.width*0.05,
                                child: Image.asset("images/fa-heart.png")
                            ),
                            Text("좋아요"),

                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                width:MediaQuery.of(context).size.width*0.05,
                                child: Image.asset("images/fa-comment-alt.png")
                            ),
                            Text("댓글 달기"),
                          ],
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

                Container(
                    //MediaQuery.of(context).size.height*0.355,
                  height:itmes_height,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1,color: Color(0xffefefef)))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height*0.1,
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: MediaQuery.of(context).size.height*0.03,),
                        child: Text(widget.info.mb_name==null?'test':widget.info.mb_name+"님의 판매상품",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.25,
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.055,),
                        child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: list_subitem
                              ),
                      ),

                    ],
                  ),
                ),

                Container(
                  //MediaQuery.of(context).size.height*0.35
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
                          children: list_extraitem
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
