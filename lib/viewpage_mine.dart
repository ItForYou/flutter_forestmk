import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterforestmk/view_item.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Viewpage_mine extends StatefulWidget {
  String wr_id;
  Viewpage_mine({Key key, this.wr_id}) : super(key: key);

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

  var itemdata,itemdata_now;
  double itmes_height=0,itmes_height2=0;
  List <Widget> list_subitem = [Container()];
  List <Widget> list_extraitem = [Container()];
  String wr_id, mb_id,ca_name,real_mbid,price="";
  Widget Swiper_widget=SizedBox();



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

  Widget get_content2(id,flg){

    var temp_data;
    String temp_price;
    if(flg==1)
      temp_data = view_item.fromJson(itemdata['data'][id]);
    else
      temp_data = view_item.fromJson(itemdata['data2'][id]);


    if(temp_data.ca_name =='업체'){
      price=temp_data.wr_subject;
    }
    else if(temp_data.wr_1 =='무료나눔'){
      price=temp_data.wr_1;
    }
    else{
      price='금액 '+temp_data.wr_1+'원';
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

      onTap: (){
        Navigator.push(context,MaterialPageRoute(
            builder:(context) => Viewpage_mine(wr_id:temp_data.wr_id)
        ));
      },
    );
    return temp;
  }

  Future<dynamic> get_data_now() async{
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_viewwr.php'),
        body: {
          "wr_id" :widget.wr_id,
        },
        headers: {'Accept' : 'application/json'}
    );
    setState(() {
      itemdata_now = jsonDecode(response.body);
      mb_id = itemdata_now['mb_id'];
      ca_name = itemdata_now['ca_name'];
      Swiper_widget = Swiper(
        itemCount: itemdata_now['files'].length,
        itemBuilder: (BuildContext context, int index){
          return Image.network(itemdata_now['files'][index]);
        },
        pagination: (itemdata_now.length)>1?SwiperPagination():null,
        loop: (itemdata_now.length)>1? true:false,
      );
      get_data();
    });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data_now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(price ,style: TextStyle(color: Colors.black),),
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
            Container(
                height: MediaQuery.of(context).size.height*0.33,
                width: MediaQuery.of(context).size.width,
                child:Swiper_widget,
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
                          border: Border.all(color: Color(0xffcccccc)),
                          image: DecorationImage(//이미지 꾸미기
                              fit:BoxFit.cover,
                              image:NetworkImage("http://forestmk.itforone.co.kr/data/member/3542386191_O4hMBHJf_d1f767e86e735db50a43847faef0544e41ede2ed.jpg")//이미지 가져오기
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
                        Text(itemdata_now==null?"테스트":itemdata_now['mb_2'],style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*0.17,
                      height: MediaQuery.of(context).size.height*0.055,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(23)),
                          border: Border.all(color: Color(0xffcccccc)),
                          color: Color(0xff515151)
                      ),
                      child: Column(
                        children: <Widget>[
                          Image.asset("images/write_icon01.png",   width: MediaQuery.of(context).size.width*0.08, height: MediaQuery.of(context).size.height*0.027,),
                          Text("완료하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.025,color: Colors.white),)
                        ],
                      ),
                    ),
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
                    Text(itemdata_now==null?'테스트':itemdata_now['wr_subject'],style: TextStyle(fontSize: 20),),
                    SizedBox(height: 10,),
                    Row(
                        children:<Widget>[
                          Text(itemdata_now==null?'테스트':itemdata_now['timegap'],style: TextStyle(fontSize: 10),),
                          SizedBox(width: 2,),
                          Text(itemdata_now==null?'테스트':itemdata_now['ca_name'],style: TextStyle(fontSize: 10),),
                        ]
                    )


                  ],
                ),

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
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.2,
            child: Text(itemdata_now==null?'테스트':itemdata_now['wr_content']),

          ),
          Container(
            height: MediaQuery.of(context).size.height*0.05,
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Text("좋아요",style: TextStyle(fontSize: 11),),
                SizedBox(width: 3,),
                Text(itemdata_now==null?'0':itemdata_now['wr_10'],),
                SizedBox(width: 3,),
                Text("댓글",style: TextStyle(fontSize: 11),),
                Text("2"),
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
    );
  }
}
