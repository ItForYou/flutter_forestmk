import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class modify_info extends StatefulWidget {
  @override
  _modify_infoState createState() => _modify_infoState();
}

class _modify_infoState extends State<modify_info> {
  String input_val ="";
  List <Widget> results_search = [];
  var profile_img;
  ImageProvider profile_widget = NetworkImage("http://14.48.175.177/theme/basic_app/img/app/wing_mb_noimg2.png");

  getGalleryImage() async {

    profile_img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      profile_widget = FileImage(profile_img);
    });

  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.34,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  child: TextFormField(
                    cursorColor: Colors.forestmk,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Color(0xffefefef))
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Color(0xffefefef))
                        ),
                        prefixIcon: Icon(Icons.search),
                        hintText: "내 동네 이름(동,읍,면)으로 검색",
                        hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.038)
                    ),
                    onChanged: (value) =>  setState(() {
                      results_search.clear();
                      for(int i=0; i<5; i++) {
                        Widget temp = Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.05,
                          child: i==0? Text("'"+value+"'"):Text("테스트 주소"),
                        );
                        results_search.add(temp);
                      }
                    }),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.height*0.04,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.015,),
                  decoration: BoxDecoration(
                      color: Colors.forestmk,
                      borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.07))
                  ),
                  child: Center(child: Text("현재위치로 찾기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,color: Colors.white))),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.17,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.04,),
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
            new FlatButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
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
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: TextFormField(
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
              height: MediaQuery.of(context).size.height*0.05,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: TextFormField(
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: MediaQuery.of(context).size.height*0.05,
                    child: TextFormField(
                        cursorColor: Colors.forestmk,
                        keyboardType: TextInputType.emailAddress,
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
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                height: MediaQuery.of(context).size.height*0.05,
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.6),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xffefefef)),
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.01,),
                ),
                child: Center(child: Text("동네선택",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, color: Color(0xff777777)),)),
              ),
              onTap: (){
                _showDialog();
              },
            ),

            Container(
              width: MediaQuery.of(context).size.width*0.61,
              height:MediaQuery.of(context).size.height*0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*0.3,
                    height:MediaQuery.of(context).size.height*0.08,
                    margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.02,),
                    decoration: BoxDecoration(
                        color: Color(0xff777777),
                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.025,))
                    ),
                    child: Center(child: Text("정보수정",style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04,fontWeight: FontWeight.bold),)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.3,
                    height:MediaQuery.of(context).size.height*0.08,
                    margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.02,),
                    decoration: BoxDecoration(
                        color: Color(0xff777777),
                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.025,))
                    ),
                    child: Center(child: Text("로그아웃",style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04,fontWeight: FontWeight.bold),)),
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
