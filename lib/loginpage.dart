
import 'package:flutter/material.dart';
import 'package:flutterforestmk/register.dart';

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
                      child: InkWell(
                        child: Text("로그인하기", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.025, fontWeight: FontWeight.bold, color: Colors.white),),
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
