import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class changehp extends StatefulWidget {

  String mb_name,mb_1,mb_2,mb_3,mb_4,mb_5,mb_6,mb_hp,mb_id;
  changehp({Key key, this.mb_name, this.mb_1, this.mb_2,this.mb_6,this.mb_5,this.mb_4,this.mb_3,this.mb_hp,this.mb_id}) : super(key: key);

  @override
  _changehpState createState() => _changehpState();
}

class _changehpState extends State<changehp> {

  TextEditingController input_ph = TextEditingController();
  TextEditingController input_certihp = TextEditingController();

  int flg_certihp =0, request_certification=0;
  String sended_number = "",mb_id;
  bool flg_readonly_hp = false;
  void show_Alert(text,flg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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

  Future<String> request_number() async {
    try {

      var request = http.MultipartRequest('POST', Uri.parse("http://14.48.175.177/bbs/ajax.send_number.php"));
      var random = Random();
      String temp_number = "";

      for(int i=0; i<6; i++){
        temp_number += random.nextInt(9).toString();
      }

      request.fields['msg'] = temp_number;
      request.fields['hp'] = input_ph.text;

      /*if (profile_img != null) {
        request.files.add(
            await http.MultipartFile.fromPath('profile', profile_img.path));
      }*/

      var res = await request.send();
      if (res.statusCode == 200) {
        show_Alert("문자가 발송되었습니다.",1);
        flg_readonly_hp = true;
        flg_certihp=0;
        sended_number = temp_number;
        request_certification=1;
        // return res.stream.bytesToString();
      }
    }catch(e){
      print(e.toString());
    }
  }

  void certification_hp(){

    if(sended_number==input_certihp.text){
      show_Alert("인증되었습니다.", 1);
      flg_certihp =1;
      request_certification=0;
    }
    else{
      show_Alert("인증번호가 올바르지 않습니다.", 1);
      flg_certihp =0;
    }
  }

  Future<dynamic> update_hp() async {
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_hp.php'),
        body: {
          "mb_id": mb_id,
          "value": input_ph.text
        },
        headers: {'Accept': 'application/json'}
    );
    // print(response.body);
    if(response.statusCode==200){
      Navigator.pop(context);
    }
  }

  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.getString('id')!=null) {
      mb_id = sp.getString('id');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    load_myinfo();
    input_ph.text = widget.mb_hp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("나의 메뉴" ,style: TextStyle(color: Colors.black),),
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
      body:Column(
          children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.07,
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05),
                child: TextFormField(
                    readOnly:  flg_readonly_hp,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter(RegExp("[0-9]")),
                    ],
                    controller: input_ph,
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                      filled: true,
                      fillColor: Color(0xfff5f5f5),
                      hintText: "핸드폰 번호를 입력해주세요",
                      border: null,
                      enabledBorder:OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                      ),
                    )
                  ),
              ),
            request_certification==1?
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.07,
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05),
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: input_certihp,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter(RegExp("[0-9]")),
                  ],
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                    filled: true,
                    fillColor: Color(0xfff5f5f5),
                    hintText: "인증번호를 입력해주세요",
                    border: null,
                    enabledBorder:OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffefefef)),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                    ),
                  )
              ),
            ):SizedBox(),
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),
              Text("핸드폰 번호는 1회만 변경 가능합니다."),
            SizedBox(height: MediaQuery.of(context).size.height*0.03,),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                height: MediaQuery.of(context).size.height*0.045,
                decoration: BoxDecoration(
                  color: Colors.forestmk,
                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.07,)),
                ),
                child: Center(child: Text("인증하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color: Colors.white),)),
              ),
              onTap: (){
                if(request_certification==0)
                  request_number();
                else
                  certification_hp();
              },
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                height: MediaQuery.of(context).size.height*0.045,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                decoration: BoxDecoration(
                  color: Colors.forestmk,
                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.07,)),
                ),
                child: Center(child: Text("변경하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color: Colors.white),)),
              ),
              onTap: (){
                update_hp();
              },
            ),





          ],
      ),
    );
  }
}
