import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterforestmk/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class modify_info extends StatefulWidget {

  String mb_name,mb_1,mb_2,mb_3,mb_4,mb_5,mb_6,mb_hp,mb_id;
  modify_info({Key key, this.mb_name, this.mb_1, this.mb_2, this.mb_hp,this.mb_3,this.mb_4,this.mb_5,this.mb_6,this.mb_id}) : super(key: key);

  @override
  _modify_infoState createState() => _modify_infoState();
}

class _modify_infoState extends State<modify_info> {
  String input_val ="";
  Widget notify_namedate=SizedBox();
  var temp_addrs;
  List <Widget> results_search = [];
  TextEditingController modify_id = new TextEditingController();
  TextEditingController modify_pwd = new TextEditingController();
  TextEditingController modify_pwd_re = new TextEditingController();
  TextEditingController modify_name = new TextEditingController();
  TextEditingController modify_ph = new TextEditingController();
  TextEditingController modify_address = new TextEditingController();
  bool flg_namereadonly = false;
  File profile_img;
  ImageProvider profile_widget=AssetImage("images/wing_mb_noimg2.png");

  getGalleryImage() async {

    profile_img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      profile_widget = FileImage(profile_img);
    });

  }

  void show_Alert(text,flg) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.03,
            child: Text(text),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: (){
                if(flg ==2)
                Navigator.of(context2).pop(true);
                Navigator.pop(context,'modify');
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
            builder:(context, setState) {
              return AlertDialog(
                title: null,
                content: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.34,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.04,
                        child: TextFormField(
                            cursorColor: Colors.forestmk,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xffefefef))
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xffefefef))
                                ),
                                prefixIcon: Icon(Icons.search),
                                hintText: "내 동네 이름(동,읍,면)으로 검색",
                                hintStyle: TextStyle(fontSize: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.038)
                            ),
                            onChanged: (value) async{
                              results_search.clear();
                              Widget temp = Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.05,
                                  child: Text("'" + value + "'")
                              );
                              results_search.add(temp);
                              final response = await http.post(
                                  Uri.encodeFull(
                                      'http://14.48.175.177/search_location.php'),
                                  body: {
                                    "value": value
                                  },
                                  headers: {'Accept': 'application/json'}
                              );
                              temp_addrs = jsonDecode(response.body);
                              setState(() {
                                change_search(context);
                              });
                            }
                        ),
                      ),
                      InkWell(
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.04,
                          margin: EdgeInsets.only(top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.015,),
                          decoration: BoxDecoration(
                              color: Colors.forestmk,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.07))
                          ),
                          child: Center(child: Text("현재위치로 찾기", style: TextStyle(
                              fontSize: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.035, color: Colors.white))),
                        ),
                        onTap: (){
                          get_location(context);
                        },
                      ),
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.17,
                        margin: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.04,),
                        child: SingleChildScrollView(
                            child: Column(
                              children: results_search,
                            )
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
//                  new FlatButton(
//                    child: new Text("확인"),
//                    onPressed: () {
//                      Navigator.pop(context);
//                    },
//                  ),
                  new FlatButton(
                    child: new Text("취소"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
        );
      },
    );
  }

  void change_search(context){

    if(temp_addrs['data'].length>0) {
      for (int i = 0; i < temp_addrs['data'].length; i++) {
        //print(temp_addrs['data'][i]);
        Widget temp = InkWell(
          child:Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.05,
            child: Text(temp_addrs['data'][i]),
          ),
          onTap: (){
              modify_address.text = temp_addrs['data'][i];
              Navigator.pop(context);
              results_search.clear();
          },
        );
        results_search.add(temp);
      }
    }
    else {
      results_search.clear();
    }

  }

  void get_location(popcontext) async{

    ProgressDialog pr = ProgressDialog(context);
    //pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: '잠시만 기다려주세요...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: Container(padding:EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),child: CircularProgressIndicator()),
      elevation: 5.0,
      insetAnimCurve: Curves.easeInOut,
    );
    pr.show();

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_current.php'),
        body: {
          "x": position.longitude.toString(),
          'y':position.latitude.toString()
        },
        headers: {'Accept': 'application/json'}
    );

    if(response.statusCode==200){
      // print(jsonDecode(response.body));
      var json_address = jsonDecode(response.body);
      String address = json_address['documents'][0]['address']['region_1depth_name']+" "+json_address['documents'][0]['address']['region_2depth_name']+" "+json_address['documents'][0]['address']['region_3depth_name'];
      modify_address.text = address;
      Navigator.pop(popcontext);
      Navigator.pop(context);

      //print(address);


    }

  }

  Future<String> uploadImage() async {
    try {
    if(modify_name.text==null || modify_name.text=='') {
      show_Alert("닉네임이 올바르지 않습니다.",1);
      return '';
    }
    else if(widget.mb_2==null || widget.mb_2=='') {
      show_Alert("주소가 올바르지 않습니다.",1);
      return '';
    }
    else if(modify_pwd.text!=null && modify_pwd.text!='' && modify_pwd.text.length <4) {
      show_Alert("비밀번호는 4자리 이상 입력되어야 합니다.",1);
      return '';
    }
    else if(modify_pwd.text !=  modify_pwd_re.text) {
      show_Alert("비밀번호 값이 일치 하지 않습니다.",1);
      return '';
    }

      var request = http.MultipartRequest('POST', Uri.parse("http://14.48.175.177/update_mbinfo.php"));
      request.fields['mb_id'] = modify_id.text;
      request.fields['mb_password'] = modify_pwd.text;
      request.fields['mb_name'] = modify_name.text;
      request.fields['mb_hp'] = modify_ph.text;
      request.fields['mb_2'] = modify_address.text;

      if (profile_img != null) {
        request.files.add(
            await http.MultipartFile.fromPath('profile', profile_img.path));
      }

      var res = await request.send();
      if (res.statusCode == 200) {

        if(modify_pwd.text!='' && modify_pwd.text!=null) {
          SharedPreferences sharedPreferences = await SharedPreferences
              .getInstance();
          sharedPreferences.setString('id', modify_id.text);
          sharedPreferences.setString('pwd', modify_pwd.text);
        }

        show_Alert("정보 수정이 완료되었습니다.",2);
       // return res.stream.bytesToString();
      }
    }catch(e){
      print(e.toString());
    }
  }

  static const _daysInMonth = const [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  bool isLeapYear(int value) =>
      value % 400 == 0 || (value % 4 == 0 && value % 100 != 0);

  int daysInMonth(int year, int month) {
    var result = _daysInMonth[month];
    if (month == 2 && isLeapYear(year)) result++;
    return result;
  }

  DateTime addMonths(DateTime dt, int value) {
    var r = value % 12;
    var q = (value - r) ~/ 12;
    var newYear = dt.year + q;
    var newMonth = dt.month + r;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    var newDay = min(dt.day, daysInMonth(newYear, newMonth));
    if (dt.isUtc) {
      return new DateTime.utc(
          newYear,
          newMonth,
          newDay,
          dt.hour,
          dt.minute,
          dt.second,
        );
    } else {
      return new DateTime(
          newYear,
          newMonth,
          newDay,
          dt.hour,
          dt.minute,
          dt.second,
        );
    }
  }

  void check_namedate() {

    if (widget.mb_4 != null && widget.mb_4 !='0000-00-00 00:00:00') {
      DateTime now = DateTime.now().toUtc();
      DateTime modified_date = DateTime.parse(widget.mb_4).toUtc();
      DateTime add1month = addMonths(modified_date, 1);
      String format_modify = modified_date.toString().substring(0,10);
      String format_addmonth = add1month.toString().substring(0,10);

      if (now.compareTo(now) <=0) {
        notify_namedate =   Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.05,
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
          child: Text("$format_modify 로 부터 1달 후, $format_addmonth이후로 변경이 가능합니다.", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.016))
        );
        flg_namereadonly = true;
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modify_name.text = widget.mb_name;
    modify_ph.text = widget.mb_hp;
    modify_id.text = widget.mb_id;
    modify_address.text = widget.mb_2;

  }

  @override
  Widget build(BuildContext context) {
    check_namedate();
    if(widget.mb_1!=null && profile_img ==null)
    profile_widget = widget.mb_1!='test'? NetworkImage(widget.mb_1):AssetImage("images/wing_mb_noimg2.png");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("회원 정보 수정" ,style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: InkWell(
          child:Padding(
              padding: EdgeInsets.all(13),
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
            InkWell(
              child: Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05, bottom: MediaQuery.of(context).size.height*0.015),
                width: MediaQuery.of(context).size.width*0.23,
                height: MediaQuery.of(context).size.width*0.23,
                decoration: BoxDecoration(
                  color: Color(0xfff0f0f0),
                  borderRadius: (BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.4,))),
                  image: DecorationImage(//이미지 꾸미기
                      fit:BoxFit.cover,
                      image:profile_widget
                  ),
                ),
              ),
              onTap: (){
                getGalleryImage();
              },
            ),
            Text("프로필사진", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.038),),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.04,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.005),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: TextFormField(
                  controller:  modify_id,
                  readOnly: true,
                  cursorColor: Colors.forestmk,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                    hintText: "아이디",
                    border: null,
                    enabledBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                  )
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.02,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.005,),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: Row(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width*0.05,
                      height: MediaQuery.of(context).size.width*0.05,
                      child: Image.asset("images/fa-exclamation-circle.png")),
                  Align(alignment: Alignment.centerLeft,child: Text("아이디는 수정할 수 없습니다.",style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.014),)),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: TextFormField(
                  obscureText: true,
                  controller: modify_pwd,
                  cursorColor: Colors.forestmk,
                  keyboardType: TextInputType.visiblePassword,
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                    hintText: "비밀번호",
                    border: null,
                    enabledBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                  )
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: TextFormField(
                  obscureText: true,
                  controller: modify_pwd_re,
                  cursorColor: Colors.forestmk,
                  keyboardType: TextInputType.visiblePassword,
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                    hintText: "비밀번호확인",
                    border: null,
                    enabledBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                  )
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: TextFormField(
                  readOnly: flg_namereadonly,
                  controller: modify_name,
                  cursorColor: Colors.forestmk,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                    hintText: "닉네임",
                    border: null,
                    enabledBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                  )
              ),
            ),
            notify_namedate,
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.002),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: MediaQuery.of(context).size.height*0.05,
                    child: TextFormField(
                        controller: modify_ph,
                        readOnly: true,
                        cursorColor: Colors.forestmk,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: InputDecoration(
                            contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                            hintText: "휴대번호",
                            border: null,
                            enabledBorder:OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                            ),
                            suffixIcon:   Container(
                              width: MediaQuery.of(context).size.width*0.2,
                              height: MediaQuery.of(context).size.height*0.05,
                              decoration: BoxDecoration(
                                color: Color(0xfff0f0f0),
                                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                              ),
                              child: Center(child: Text("인증")),
                            )
                        )
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,

              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: Row(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width*0.05,
                      height: MediaQuery.of(context).size.width*0.05,
                      child: Image.asset("images/fa-exclamation-circle.png")),
                  Align(alignment: Alignment.centerLeft,child: Text("휴대번호 변경시 앱설정에서 변경바랍니다.",style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.016),)),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: TextFormField(
                  readOnly: true,
                  controller: modify_address,
                  onTap: _showDialog,
                  cursorColor: Colors.forestmk,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                    hintText: widget.mb_2!=null? widget.mb_2:'동네선택',
                    border: null,
                    enabledBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                  )
              ),
            ),
//            InkWell(
//              child: Container(
//                width: MediaQuery.of(context).size.width*0.8,
//                height: MediaQuery.of(context).size.height*0.05,
//                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
//                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.35),
//                decoration: BoxDecoration(
//                  border: Border.all(width: 1, color: Color(0xffefefef)),
//                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
//                ),
//                child: Center(child: Text(widget.mb_2,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.038, color: Color(0xff777777)),)),
//              ),
//              onTap: (){
//                _showDialog();
//              },
//            ),

            Container(
              width: MediaQuery.of(context).size.width*0.61,
              height:MediaQuery.of(context).size.height*0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      height:MediaQuery.of(context).size.height*0.07,
                      margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.02,),
                      decoration: BoxDecoration(
                          color: Color(0xff444444),
                          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.01,))
                      ),
                      child: Center(child: Text("정보수정",style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.035,fontWeight: FontWeight.bold),)),
                    ),
                    onTap:()async{
                      var result = await uploadImage();
                      //print(result);
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      height:MediaQuery.of(context).size.height*0.07,
                      margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.02,),
                      decoration: BoxDecoration(
                          color: Color(0xff444444),
                          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.01,))
                      ),
                      child: Center(child: Text("로그아웃",style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.035,fontWeight: FontWeight.bold),)),
                    ),
                    onTap: ()async{
                      SharedPreferences sp = await SharedPreferences.getInstance();
                      sp.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MyApp()),
                              (Route<dynamic> route) => false);
                    },
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
