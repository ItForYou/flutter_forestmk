import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutterforestmk/categorypage.dart';
import 'package:flutterforestmk/chat_webview.dart';
import 'package:flutterforestmk/chk_writead.dart';
import 'package:flutterforestmk/location.dart';
import 'package:flutterforestmk/main_home.dart';
import 'package:flutterforestmk/member/loginpage.dart';
import 'package:flutterforestmk/main.dart';
import 'package:flutterforestmk/main_item.dart';
import 'package:flutterforestmk/search_main.dart';
import 'package:flutterforestmk/member/mypage.dart';
import 'package:flutterforestmk/border/viewpage.dart';
import 'package:flutterforestmk/border/write_normal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class my_items extends StatefulWidget {

  String mb_name,mb_1,mb_2,mb_3,mb_4,mb_5,mb_6,mb_hp,mb_id,mb_pwd,title,sch_mbid;
  my_items({Key key, this.title,this.mb_name, this.mb_1, this.mb_2,this.mb_6,this.mb_5,this.mb_4,this.mb_3,this.mb_hp,this.mb_id,this.mb_pwd, this.sch_mbid}) : super(key: key);

  @override
  _my_itemsState createState() => _my_itemsState();
}

class _my_itemsState extends State<my_items> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static double scrollbar_height=1;
  double list_height;
  int start_height=1;
  PreferredSize appbar;
  List <bool> checkbox_values;
  bool flg_allcheck = false;
  bool flg_search = false;
  List <Widget> items_content=[];
  Widget head_first, mb_infowidget=Text("로그인 후, 이용해주세요",style: TextStyle(color: Color(0xff888888),fontSize: 12));
  var itemdata;
  ScrollController change_appbar = ScrollController();
  TextEditingController search_text = new TextEditingController();
  PreferredSize intro_appbar = PreferredSize(
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
      preferredSize:Size.fromHeight(0),
      child:AppBar(
        automaticallyImplyLeading: false,
        title: null,
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions:null,
      )
  );
  PreferredSize scroll_appbar;

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

    setState(() {

      widget.mb_hp = temp_mbdata['mb_hp'];
      widget.mb_name = temp_mbdata['mb_name'];
      if(temp_mbdata['mb_1']!='')
        widget.mb_1 = "http://14.48.175.177/data/member/"+temp_mbdata['mb_1'];
      else
        widget.mb_1 = "test";
      widget.mb_2 = temp_mbdata['mb_2'];
      widget.mb_3 = temp_mbdata['mb_3'];
      widget.mb_4 = temp_mbdata['mb_4'];
      widget.mb_5 = temp_mbdata['mb_5'];
      widget.mb_6 = temp_mbdata['mb_6'];

    });
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

  _changeappbar() {

    double scrollposition = change_appbar.position.pixels;

    if (scrollposition > 100) {
      setState(() {
        if(appbar != scroll_appbar)
          appbar = scroll_appbar;
        if(list_height == MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.049) {
          start_height =0;
          list_height = list_height - MediaQuery.of(context).size.height*0.08;
        }
      });
    }
    else {
      setState(() {

        if(appbar == scroll_appbar) {
          appbar = intro_appbar;
          start_height =0;
          list_height = list_height + MediaQuery.of(context).size.height*0.08;
        }
        //실값이 반올림되어져 비교되어짐 그래서 값이 다르게 나옴
        /*if(list_height  == MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.23) {

         }*/
      });
    }
  }

  Future<dynamic> delete_recent() async{

    List <String> checked_id=[];
    for(int i=0; i<checkbox_values.length; i++){
      if(checkbox_values[i] == true)
        checked_id.add(itemdata['data'][i]['wr_id']);
    }

    if(checked_id.length<=0){
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse("http://14.48.175.177/delete_myitems.php"));

    request.fields['mb_id'] = widget.mb_id;
    request.fields['title'] = widget.title;

    for(int i=0; i<checked_id.length; i++){
      request.fields['wr_id['+i.toString()+']'] = checked_id[i];
    }

    var res = await request.send();
    if (res.statusCode == 200) {
     // return res.stream.bytesToString();
     setState(() {
        get_data();
      });
    }
  }

  Widget get_content(id){

    var temp_data = main_item.fromJson(itemdata['data'][id]);

    String temp_price;
    String temp_wrcontent;

    if(temp_data.ca_name =='업체'){
      temp_price=temp_data.wr_subject;
    }
    else if(temp_data.wr_1 =='무료나눔'){
      temp_price=temp_data.wr_1;
    }
    else{
      if(temp_data.wr_1.contains(','))
        temp_price = temp_data.wr_1+"원";
      else {
        MoneyFormatterOutput fmf = FlutterMoneyFormatter(
            amount: double.parse(temp_data.wr_1)).output;
        temp_price = fmf.withoutFractionDigits.toString() + '원';
      }
    }

    if(temp_data.ca_name=='업체'){
      temp_wrcontent = temp_data.wr_content.replaceAll('\n','              ');
      if(temp_wrcontent.length<15){

      }
      else{
        temp_wrcontent = temp_wrcontent.substring(0,12)+"···";
      }
    }

    Container temp =
    Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Color(0xffdddddd), width: 1)
            )
        ),
        padding: EdgeInsets.only(left: 10,right: 20,top:10,bottom: 10),
        child: InkWell(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  Row(
                      children: <Widget>[
                        widget.title.toString().contains("님의 판매상품")==false?
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.055,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white
                            ),
                            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.03),
                            alignment: Alignment.center,
                            child: Container(
                              width: 20,
                              height: 20,
                             decoration: BoxDecoration(
                                 color:Color(0xffeeeeee),
                                 borderRadius: BorderRadius.all(Radius.circular(5))
                             ),

                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: Color(0xffeeeeee),
                                ),
                                child: Checkbox(
                                  value: checkbox_values[id],
                                  activeColor: Colors.black12,
                                  onChanged: (bool value){
                                    setState(() {
                                      checkbox_values[id] = value;
                                      _getWidget();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              checkbox_values[id] = !checkbox_values[id];
                              _getWidget();
                            });
                          },
                        ):Container(),
                        InkWell(
                          child: Hero(
                            tag: "hero"+id.toString(),
                            child:
                            temp_data.wr_9!='거래완료'?
                            Container(
                              width: MediaQuery.of(context).size.width*0.225,
                              height: MediaQuery.of(context).size.width*0.2,

                              decoration: BoxDecoration(
                                  border:  temp_data.ca_name=='업체'? Border.all(width: 2,color: Colors.forestmk):null,
                                  borderRadius: BorderRadius.all(Radius.circular( MediaQuery.of(context).size.width*0.015)),
                                  image: DecorationImage(//이미지 꾸미기
                                      fit:BoxFit.cover,
                                      image:temp_data.file[0]=='nullimage'? AssetImage("images/noimg.jpg"): NetworkImage(temp_data.file[0])//이미지 가져오기
                                  )
                              ),
                            ):Stack(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.225,
                                    height: MediaQuery.of(context).size.height*0.2,
                                    decoration: BoxDecoration(
                                        border:  temp_data.ca_name=='업체'? Border.all(width: 2,color: Colors.forestmk):null,
                                        borderRadius: BorderRadius.all(Radius.circular( MediaQuery.of(context).size.width*0.015)),
                                        image: DecorationImage(//이미지 꾸미기
                                            fit:BoxFit.fitWidth,
                                            image:temp_data.file[0]=='nullimage'? AssetImage("images/noimg.jpg"): NetworkImage(temp_data.file[0])//이미지 가져오기
                                        )
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.225,
                                    height: MediaQuery.of(context).size.height*0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8)
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.225,
                                        height: MediaQuery.of(context).size.height*0.04,
                                        decoration: BoxDecoration(
                                            color: Colors.white
                                        ),
                                        child: Center(child: Text("판매완료", style: TextStyle(color: Color(0xff000000),fontSize: MediaQuery.of(context).size.width*0.035, decoration: TextDecoration.none, fontWeight: FontWeight.normal))),
                                      ),
                                    ),
                                  )
                                ]
                            ),
                          ),
                          onTap: ()async{
                            var result = await Navigator.push(context, PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 800),
                              pageBuilder: (_, __, ___) => Viewpage(tag:"hero"+id.toString(), src:temp_data.file[0],info: temp_data,mb_id :widget.mb_id,mb_pwd:widget.mb_pwd,mb_1: widget.mb_1,mb_2: widget.mb_2,
                                mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,),
                            ));
                            if(result == 'delete'){
                              get_data();
                            }
//        Navigator.push(context,MaterialPageRoute(
//            builder:(context) => Viewpage(tag:"hero"+id.toString(), src:temp_data.file[0],info: temp_data,)
//        ));
                          },
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: MediaQuery.of(context).size.height*0.003,),
                              Text(temp_data.wr_subject.length<15?temp_data.wr_subject:temp_data.wr_subject.substring(0,12)+"···", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035),),
                              SizedBox(height: MediaQuery.of(context).size.height*0.003,),
                              Text(temp_data.ca_name=='업체'?temp_wrcontent:temp_price, style: TextStyle(fontSize: temp_data.ca_name!='업체'?MediaQuery.of(context).size.width*0.035:MediaQuery.of(context).size.width*0.03,fontWeight: temp_data.ca_name=='업체'?null:FontWeight.bold),),
                              SizedBox(height: MediaQuery.of(context).size.height*0.005,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(temp_data.ca_name=='업체'?temp_data.wr_11:temp_data.mb_2,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025,color:Color(0xff444444))),
                                  SizedBox(width: MediaQuery.of(context).size.width*0.005,),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.01,
                                    height: MediaQuery.of(context).size.width*0.01,
                                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.005,right: MediaQuery.of(context).size.width*0.005,),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.05,)),
                                        color: Colors.forestmk
                                    ),
                                  ),
                                  Text(temp_data.timegap,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)),
                                ],
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height*0.0075,),
                              Row(
                                children: <Widget>[
                                  Text(temp_data.ca_name=="업체"?"광고업체":temp_data.ca_name, style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)),
                                  Image.asset("images/fa-angle-right.png", height: MediaQuery.of(context).size.height*0.018,),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.01,
                                    height: MediaQuery.of(context).size.width*0.01,
                                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.005,right: MediaQuery.of(context).size.width*0.005,),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.05,)),
                                        color: Colors.forestmk
                                    ),
                                  ),
                                  Image.asset("images/fa-heart.png",height: MediaQuery.of(context).size.height*0.018,),
                                  Text(temp_data.like, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.026,)),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.01,
                                    height: MediaQuery.of(context).size.width*0.01,
                                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.005,right: MediaQuery.of(context).size.width*0.005,),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.05,)),
                                        color: Colors.forestmk
                                    ),
                                  ),
                                  Image.asset("images/fa-comment.png",height: MediaQuery.of(context).size.height*0.018,),
                                  Text("0", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.026)),
                                ],
                              ),
                            ],
                          ),
                          onTap: ()async{
                            var result = await Navigator.push(context, PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 800),
                              pageBuilder: (_, __, ___) => Viewpage(tag:"hero"+id.toString(), src:temp_data.file[0],info: temp_data,mb_id :widget.mb_id,mb_pwd:widget.mb_pwd,mb_1: widget.mb_1,mb_2: widget.mb_2,
                                  mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name),
                            ));
                            if(result == 'delete'){
                              get_data();
                            }
                          },
                        ),]
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          //border: Border.all(color: Color(0xffcccccc)),
                          color: Color(0xfff3f3f3),
                          image: DecorationImage(//이미지 꾸미기
                              fit:BoxFit.cover,
                              image:temp_data.profile_img==''?AssetImage("images/wing_mb_noimg2.png"):NetworkImage(temp_data.profile_img)//이미지 가져오기
                          )
                      ),
                    ),
                    SizedBox(height: 6,),
                    Text(temp_data.mb_name.length<5?temp_data.mb_name:temp_data.mb_name.substring(0,3)+"···",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03),)
                  ],
                ),
              ],
            ),
          onTap: ()async{
            var result = await Navigator.push(context, PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 800),
              pageBuilder: (_, __, ___) => Viewpage(tag:"hero"+id.toString(), src:temp_data.file[0],info: temp_data,mb_id :widget.mb_id,mb_pwd:widget.mb_pwd,mb_1: widget.mb_1,mb_2: widget.mb_2,
                  mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name),
            ));
            if(result == 'delete'){
              get_data();
            }
          },
        ),
      );
    return temp;
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
            child: Wrap(children: [
              Text(text),
            ]
            ),
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

  void _showcontent() {

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.2,
            child: Column(
              children: <Widget>[

                InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.1,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
                    child: Row(
                      children: <Widget>[

                        Image.asset("images/write_icon01.png"),
                        SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                        Text("중고거래 글쓰기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)
                      ],
                    ),
                  ),
                  onTap: ()async{
                    var result = await  Navigator.push(context,MaterialPageRoute(
                        builder:(context) => write_normal()
                    ));
                    if(result == 'success'){
                      // print(result);
                      Navigator.pop(bc);
                      //show_Alert("승인을 기다려주세요!\n승인시 자동 업로드 됩니다.",1);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("글 등록이 완료 되었습니다."),));
                      //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("승인을 기다려주세요!"),));
                      get_data();
                    }
                    else{
                      Navigator.pop(bc);
                      get_data();
                    }
                  },
                ),
                InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.1,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
                    child: Row(
                      children: <Widget>[
                        Image.asset("images/write_icon02.png"),
                        SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                        Text("광고업체 글쓰기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)
                      ],
                    ),
                  ),
                  onTap: ()async{
                    var result = await  Navigator.push(context,MaterialPageRoute(
                        builder:(context) => chk_writead()
                    ));
                    if(result == 'success'){
                      // print(result);
                      Navigator.pop(bc);
                      show_Alert("승인을 기다려주세요!\n승인시 자동 업로드 됩니다.",1);
                      //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("승인을 기다려주세요!"),));
                      get_data();
                    }
                    else{
                      Navigator.pop(bc);
                      get_data();
                    }
                  },
                ),

              ],
            ),
          );
        }
    );
  }

  void show_deletealrt(){
    //print(checkbox_values.length.toString());
    if(checkbox_values.contains(true)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: null,
            content: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.03,
              child: Text("선택한 게시물을 삭제하시겠습니까?"),
            ),
            actions: <Widget>[

              new FlatButton(
                child: new Text("취소", style: TextStyle(color: Colors.red),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("확인"),
                onPressed: () async {
                  Navigator.pop(context);
                  var result = await delete_recent();
                  //print(result);
                },
              ),
            ],
          );
        },
      );
    }
    else {
      show_Alert("항목을 선택해 주세요!", 1);
    }
  }

  Future<dynamic> get_data() async{


    String url ="";

    if(widget.title=="최근 본 글"){
       url="http://14.48.175.177/get_myrecent.php";
    }
    else if(widget.title=="광고중인 게시글"){
      url="http://14.48.175.177/get_myadv.php";
    }
    else{
       url="http://14.48.175.177/get_mywrite.php";
    }

    final response = await http.post(
        Uri.encodeFull(url),
        body: {
          'mb_id':widget.title.toString().contains("님의 판매상품")==false?widget.mb_id:widget.sch_mbid,
          'sch_text':search_text.text!=''?search_text.text:'',
        },
        headers: {'Accept' : 'application/json'}
    );

      itemdata = jsonDecode(response.body);
      checkbox_values = List<bool>(itemdata['data'].length);
      for(int i=0; i< itemdata['data'].length; i++){
        checkbox_values[i] = false;
      }
      _getWidget();
  }

  _getWidget(){
    if(itemdata.length<0){
      setState(() {
        items_content.add(Container());
      });
    }
    else {
      setState((){
        items_content.clear();
        for (var i = 0; i < itemdata['data'].length; i++) {
          items_content.add(get_content(i));
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    appbar = intro_appbar;
    change_appbar.addListener(_changeappbar);

    get_data();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //load_myinfo();
    print(widget.mb_id);

    if(widget.mb_id !=null && widget.mb_id!='') {
      mb_infowidget  = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height*0.015,),
          Text(widget.mb_name.length>10?widget.mb_name.substring(0,10)+"···":widget.mb_name,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.032,fontWeight: FontWeight.bold),),
          Text(widget.mb_2,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, color: Color(0xff666666))),
        ],
      );
    }
  //상단 검색바 표시 부분
    if(flg_search == false) {
      head_first = Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.075,
          decoration: new BoxDecoration(color: Colors.white),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: MediaQuery
                      .of(context)
                      .size
                      .width * 0.05, top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.016, bottom: MediaQuery
                      .of(context)
                      .size
                      .height * 0.016),
                  child: Image.asset("images/logo_name.png", fit: BoxFit.fill,),
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.085,
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * 0.085,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: Color(0xffeeeeee))
                        ),
                        child: Image.asset("images/hd_icon01.png"),
                      ),
                      onTap: () {
                        setState(() {
                          if(flg_search==false)
                            flg_search = true;
                          else
                            flg_search = false;
                        });
                      },
                    ),

                    SizedBox(width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.03,),
                    InkWell(
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.09,
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * 0.09,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: Color(0xffeeeeee))
                        ),
                        child: Image.asset("images/hd_icon02.png"),
                      ),
                      onTap: () async {
                        if(widget.mb_id!=null && widget.mb_id !='') {

                          var result = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => location(mb_2:widget.mb_2, mb_id:widget.mb_id)
                          ));
                          if(result == 'change'){
                            get_mbdata();
                            get_data();
                          }
                        }
                        else{
                          request_logindialog();
                        }
                      },
                    ),
                    SizedBox(width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.03,),
                    InkWell(
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.09,
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * 0.09,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: Color(0xffeeeeee))
                        ),
                        child: Image.asset("images/hd_icon03.png"),
                      ),
                      onTap: () async{
                        if(widget.mb_id!=null && widget.mb_id!='') {
                          var result = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => chat_webview(url:"http://14.48.175.177/bbs/login_check.php?mb_id="+widget.mb_id+"&mb_password="+widget.mb_pwd+"&flg_flutter=1")
                          ));
                          if(result == 'change'){
                            get_data();
                          }
                        }
                        else{
                          request_logindialog();
                        }
                      },
                    ),
                    SizedBox(width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.02,),
                  ],
                )
              ]
          )
      );
    }
    else{

      head_first = Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.075,
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04,right: MediaQuery.of(context).size.width*0.04,top:  MediaQuery.of(context).size.height * 0.001,bottom:  MediaQuery.of(context).size.height * 0.001,),
          decoration: new BoxDecoration(
              color: Colors.white
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width*0.8,
                height: MediaQuery.of(context).size.height * 0.075,
                child:TextFormField(
                  controller: search_text,
                  maxLines: 1,
                  maxLength: null,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xfff9f9f9),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1,color: Color(0xffefefef))
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1,color: Color(0xffefefef))
                    ),
                    suffixIcon:
                    InkWell(
                      child: Icon(Icons.search),
                      onTap: (){
                        get_data();
//                        Navigator.push(context,MaterialPageRoute(
//                            builder:(context) => search_main(sch_text: search_text.text, mb_id:widget.mb_id,mb_pwd:widget.mb_pwd,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,)
//                        ));
                      },
                    ),
                    hintText: "원하시는 키워드를 입력하세요",
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.02,),
              InkWell(
                child:
                Icon(
                  Icons.clear,
                  color: Colors.forestmk,
                  size: MediaQuery.of(context).size.width*0.08,),
                onTap: (){
                  setState(() {
                    if(flg_search==false)
                      flg_search = true;
                    else
                      flg_search = false;
                  });
                },
              ),
            ],
          )
      );
    }

    if(start_height == 1){
      list_height = MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.049;
      scrollbar_height = MediaQuery.of(context).size.height*0.08;
      scroll_appbar = PreferredSize(
          preferredSize: Size.fromHeight(scrollbar_height),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: null,
            elevation: 0.0,
            backgroundColor: Colors.white,
            actions: <Widget>[
              Container(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.07,right: MediaQuery.of(context).size.width*0.07,top: 10,bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: 40,
                        height: scrollbar_height*0.8,
                        padding: EdgeInsets.all(3),
                        child: Image.asset("images/hd_cate01.png"),
                      ),
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(
                            builder:(context) => main_home(mb_id:widget.mb_id)
                        ));
                      },
                    ),

                    InkWell(
                      child: Container(
                        width: 40,
                        height: scrollbar_height*0.8,
                        padding: EdgeInsets.all(3),
                        child: Image.asset("images/hd_cate02.png"),
                      ),
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(
                            builder:(context) => search_main(title:'광고',sch_flgadv: "1", mb_id:widget.mb_id,mb_pwd:widget.mb_pwd,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,)
                        ));
                      },
                    ),

                    InkWell(
                      child: Container(
                        width: 40,
                        height: scrollbar_height*0.8,
                        padding: EdgeInsets.all(3),

                        child: Image.asset("images/hd_cate03.png"),
                      ),
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(
                            builder:(context) => categorypage(mb_id:widget.mb_id,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,)
                        ));
                      },
                    ),

                    InkWell(
                      child: Container(
                        width: 40,
                        height: scrollbar_height*0.8,
                        padding: EdgeInsets.all(3),

                        child: Image.asset("images/hd_cate04.png"),
                      ),
                      onTap: (){
                        if(widget.title=='최근 본 글')
                          get_data();
                        else if(widget.mb_id ==null || widget.mb_id ==''){
                          request_logindialog();
                        }
                        else {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  my_items(title: "최근 본 글",
                                    mb_id: widget.mb_id,
                                    mb_pwd: widget.mb_pwd,
                                    mb_1: widget.mb_1,
                                    mb_2: widget.mb_2,
                                    mb_3: widget.mb_3,
                                    mb_4: widget.mb_4,
                                    mb_hp: widget.mb_hp,
                                    mb_5: widget.mb_5,
                                    mb_6: widget.mb_6,
                                    mb_name: widget.mb_name,)
                          ));
                        }
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 40,
                        height: scrollbar_height*0.8,
                        padding: EdgeInsets.all(3),

                        child: Image.asset("images/hd_cate05.png"),
                      ),
                      onTap: ()async{

                        if(widget.mb_id ==null || widget.mb_id ==''){
                        request_logindialog();
                        }

                        else {
                          var result = await Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) =>
                                  mypage(mb_id: widget.mb_id,
                                    mb_1: widget.mb_1,
                                    mb_2: widget.mb_2,
                                    mb_3: widget.mb_3,
                                    mb_4: widget.mb_4,
                                    mb_hp: widget.mb_hp,
                                    mb_5: widget.mb_5,
                                    mb_6: widget.mb_6,
                                    mb_name: widget.mb_name,)
                          ));
                          if (result == 'back') {
                            get_mbdata();
                            get_data();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
      );
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: appbar,
//      decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(Radius.circular(50)),
//          border: Border.all(color: Color(0xffcccccc))
//      ),
      body:
/*      Column(
        children: <Widget>[
          Container(
            height: list_height,
            decoration: BoxDecoration(color: Colors.white),
            child:*/
            ListView(
              controller: change_appbar,
              children: <Widget>[
                SizedBox(height: 5,),
                head_first,
                Container(
                    padding: EdgeInsets.only(left: 22, right: 22),
                    height: MediaQuery.of(context).size.height*0.075,
                    decoration: new BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),
                            child: Image.asset("images/hd_cate01.png"),
                          ),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(
                                builder:(context) => main_home(mb_id: widget.mb_id,)
                            ));
                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.asset("images/hd_cate02.png"),
                          ),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(
                                builder:(context) => search_main(title:'광고',sch_flgadv: "1", mb_id:widget.mb_id,mb_pwd:widget.mb_pwd,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,)
                            ));
                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.asset("images/hd_cate03.png"),
                          ),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(
                                builder:(context) => categorypage(mb_id:widget.mb_id,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,)
                            ));
                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.asset("images/hd_cate04.png"),
                          ),
                          onTap: (){
                            if(widget.title=='최근 본 글')
                              get_data();
                            else if(widget.mb_id ==null || widget.mb_id ==''){
                              request_logindialog();
                            }
                            else {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      my_items(title: "최근 본 글",
                                        mb_id: widget.mb_id,
                                        mb_pwd: widget.mb_pwd,
                                        mb_1: widget.mb_1,
                                        mb_2: widget.mb_2,
                                        mb_3: widget.mb_3,
                                        mb_4: widget.mb_4,
                                        mb_hp: widget.mb_hp,
                                        mb_5: widget.mb_5,
                                        mb_6: widget.mb_6,
                                        mb_name: widget.mb_name,)
                              ));
                            }
                          },
                        ),

                        InkWell(
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(3),

                            child: Image.asset("images/hd_cate05.png"),
                          ),
                          onTap: ()async{

                            if(widget.mb_id ==null || widget.mb_id ==''){
                              request_logindialog();
                            }
                            else {
                              var result = await Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context) =>
                                      mypage(mb_id: widget.mb_id,
                                        mb_1: widget.mb_1,
                                        mb_2: widget.mb_2,
                                        mb_3: widget.mb_3,
                                        mb_4: widget.mb_4,
                                        mb_hp: widget.mb_hp,
                                        mb_5: widget.mb_5,
                                        mb_6: widget.mb_6,
                                        mb_name: widget.mb_name,)
                              ));
                              if (result == 'back') {
                                get_mbdata();
                                get_data();
                              }
                            }
                          },
                        ),


                      ],
                    )),
                Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    decoration: BoxDecoration(color: Colors.white),
                    padding:EdgeInsets.only(left: 22,right: 22),
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                               Container(
                                width: MediaQuery.of(context).size.width*0.12,
                                height: MediaQuery.of(context).size.width*0.12,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Color(0xfff3f3f3),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
//                                    border: Border.all(color: Color(0xffcccccc)),
                                    image: DecorationImage(//이미지 꾸미기
                                      fit:BoxFit.cover,
                                      //image:  AssetImage("images/wing_mb_noimg2.png"),
                                      image:widget.mb_1=='test'?
                                      AssetImage("images/wing_mb_noimg2.png"):
                                      NetworkImage( widget.mb_1,),
                                    )

                                ),
                            ),
                            SizedBox(width: 10,),
                            InkWell(
                              child: Center(child: mb_infowidget),
                              onTap: ()async{
                                if(widget.mb_id==null || widget.mb_id=='') {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => loginpage()
                                  ));
                                  /*if(result!=null){
                                    setState(() {

                                    });
                                  }*/
                                }
                                else{
                                  var result = await   Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => mypage(mb_id:widget.mb_id,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,)
                                  ));
                                  if(result == 'back'){
                                    get_mbdata();
                                    get_data();
                                  }
                                /*  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => mypage(mb_id:widget.mb_id,mb_1: widget.mb_1,mb_2: widget.mb_2,mb_3: widget.mb_3, mb_4: widget.mb_4, mb_hp: widget.mb_hp, mb_5: widget.mb_5, mb_6: widget.mb_6,mb_name: widget.mb_name,)
                                  ));*/
                                }
                              },
                            ),
                          ],
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.25,
                            height: MediaQuery.of(context).size.height*0.035,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Color(0xff444444),
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                border: Border.all(color: Color(0xffcccccc))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(3),
                                  child:Image.asset("images/mb_write_btn.png"),
                                ),
                                Text("글쓰기",style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                          onTap: (){
                            if(widget.mb_id!=null && widget.mb_id !='') {
                              _showcontent();
                            }
                            else{
                              request_logindialog();
                            }
                          },
                        ),
                      ],
                    )
                ),
                Container(
                    padding: EdgeInsets.only(left: 22, right: 22),
                    height: MediaQuery.of(context).size.height*0.05,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xfff7f7f7), width: 2),
                          bottom: BorderSide(color: Color(0xfff7f7f7), width: 2),
                        )

                    ),

                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                            Text(widget.title ,style: TextStyle(fontSize:MediaQuery.of(context).size.width*0.04)),
                        widget.title.toString().contains("님의 판매상품")==false?
                        Row(
                          children: <Widget>[
                            InkWell(
                                child: Text("모두선택",style: TextStyle(color: Colors.forestmk),),
                                onTap: (){
                                  setState(() {
                                    bool all_value;
                                    if(flg_allcheck==false) {
                                            flg_allcheck=true;
                                            all_value = true;
                                      }
                                    else{
                                      flg_allcheck=false;
                                      all_value = false;
                                    }
                                      for (int i = 0; i < checkbox_values.length; i++) {
                                        checkbox_values[i] = all_value;
                                    }
                                      _getWidget();
                                  });
                                },
                            ),
                            SizedBox(width:  MediaQuery.of(context).size.width*0.03,),

                            InkWell(
                                child: Text("지우기",style: TextStyle(color: Colors.forestmk),),
                                onTap: (){
                                  show_deletealrt();
                                },
                            ),
                          ],
                        ):Container(),
                      ],
                    ),

                ),
                Column(
                    children: items_content
                )
              ],
            ),

// 광고 살릴시 필요
//          ),
//        ],
//      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
