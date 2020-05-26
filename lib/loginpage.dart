
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterforestmk/main.dart';
import 'package:flutterforestmk/register.dart';
import 'package:flutterforestmk/search_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class loginpage extends StatefulWidget {

  loginpage({Key key, this.title,}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _loginpageState createState() => _loginpageState();
}

class _loginpageState extends State<loginpage>{
  SharedPreferences sharedPreferences;
  final input_id = TextEditingController();
  final input_pwd = TextEditingController();

  void login_fail() {
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
                      Text("로그인 정보가 올바르지 않습니다.", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),)
                ],
              ),
            ),
            actions:  <Widget>[
              new FlatButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]
        );
      },
    );
  }


  Future<dynamic> check_login(id, pwd) async{
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/check_login.php'),
        body: {
          "id":id,
          "pwd":pwd
        },
        headers: {'Accept' : 'application/json'}
    );
    setState(() async {
      var result_login = jsonDecode(response.body);
      if(result_login['flg']=='1'){

        sharedPreferences =await SharedPreferences.getInstance();
        sharedPreferences.setString('id', id);
        sharedPreferences.setString('pwd', pwd);
        sharedPreferences.setString('mb_name', result_login['mb_name']);
        sharedPreferences.setString('mb_2', result_login['mb_2']);
        //print("test"+result_login['mb_1'].toString());
       sharedPreferences.setString('mb_1', result_login['mb_1']);


          // will be null if never previously saved
        Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false);
        }
      else{
        login_fail();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          title: null,
          elevation: 0.0,
          backgroundColor: Colors.white,
          actions:null,
        ),

      ),
       body:Container(
          height: MediaQuery.of(context).size.height*0.73,
          padding: EdgeInsets.only(top :MediaQuery.of(context).size.height*0.15,),
         child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.09,
                padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.018),
                child:Image.asset("images/logo.png",)
              ),

              Column(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Color(0xfff5f5f5)
                      ),
                      child: TextField(
                        controller: input_id,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only( left: 20),
                          hintText: "회원아이디",
                          hintStyle: TextStyle(color: Color(0xff8c8c8c), fontWeight: FontWeight.bold, fontSize:  MediaQuery.of(context).size.width*0.04,),
                          ),
                      )
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.008,),
                  Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height*0.01,)),
                          color: Color(0xfff5f5f5)
                      ),
                      child:TextField(
                        controller: input_pwd,
                        cursorColor: Colors.green,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only( left: 20),
                          hintText: "비밀번호",
                          hintStyle: TextStyle(color: Color(0xff8c8c8c), fontWeight: FontWeight.bold,fontSize:  MediaQuery.of(context).size.width*0.04,),
                        ),
                      )
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height*0.003,),
              InkWell(
                child: Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    height: MediaQuery.of(context).size.height*0.08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Color(0xff4d4d4d)
                    ),
                    child:Center(
                        child: Text("로그인하기", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.025, fontWeight: FontWeight.bold, color: Colors.white),),
                      ),
                    ),
                onTap: (){
                      check_login(input_id.text,input_pwd.text);
                },
              ),
              InkWell(
                child: Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    height: MediaQuery.of(context).size.height*0.07,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Color(0xffffd900)
                    ),
                    child:Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                              Container(
                                width: 20,
                                height: 20,
                                child: Image.asset("images/log_sns_ka.png"),
                              ),
                            SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                            Text("카카오톡 아이디로 로그인",style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02),)
                          ],
                        ),
                    )
                ),
              ),
              InkWell(
                child: Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    height: MediaQuery.of(context).size.height*0.07,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Color(0xff1ec800)
                    ),
                    child:Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 20,
                            height: 20,
                            child: Image.asset("images/log_sns_na.png"),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                          Text("네이버 아이디로 로그인",style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.height*0.02))
                        ],
                      ),
                    )
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height*0.06,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: InkWell(
                        child: Text("아이디/비밀번호 찾기",textAlign: TextAlign.right,style: TextStyle(fontSize:MediaQuery.of(context).size.height*0.018,decoration: TextDecoration.underline,color: Colors.black, fontWeight: FontWeight.bold),),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(
                              builder:(context) => search_info()
                          ));
                        },
                      ),
                    ),
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height*0.01,),
                        width: MediaQuery.of(context).size.width*0.7,
                          child: Text("숲마켓 회원가입", textAlign: TextAlign.right,style: TextStyle(fontSize:MediaQuery.of(context).size.height*0.018,decoration: TextDecoration.underline,color: Colors.black, fontWeight: FontWeight.bold),),
                      ),
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(
                            builder:(context) => register()
                        ));
                      }
                    )
                  ],
                ),
              ),
            ],
         ),
        )
    );
  }


}
