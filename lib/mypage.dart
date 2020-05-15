import 'package:flutter/material.dart';
import 'package:flutterforestmk/location.dart';
import 'package:flutterforestmk/mysetting.dart';


class mypage extends StatefulWidget {
  @override
  _mypageState createState() => _mypageState();
}

class _mypageState extends State<mypage> {

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.02,
            child: Text("로그아웃 하시겠습니까?"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: () {
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
        title: Text("홈으로" ,style: TextStyle(color: Colors.black),),
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
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.05,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xfff7f7f7),width: 1),
                  )
                ),
                child: Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                    child:
                    Text("나의 메뉴", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),)
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.12,
                padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.03,right:MediaQuery.of(context).size.width*0.03,),
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xfff7f7f7),width: 1),
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width*0.15,
                            height: MediaQuery.of(context).size.width*0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.5,)),
                                image: DecorationImage(//이미지 꾸미기
                                    fit:BoxFit.cover,
                                    image:NetworkImage("http://14.48.175.177/data/member/3076986471_Ij38ZOJV_78013042bb23282d414ec7602b46292f0d8bc89a.jpg")//이미지 가져오기
                            ),
                          )
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("테스트1",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,fontWeight: FontWeight.bold),),
                                SizedBox(height: MediaQuery.of(context).size.height*0.005,),
                                Text("부산광역시 수영구 광안동 ", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03,),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.23,
                      height: MediaQuery.of(context).size.width*0.08,
                      decoration: BoxDecoration(
                        color: Color(0xff444444),
                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.5,)),
                      ),
                      child: Center(child: Text("프로필편집", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035, color: Colors.white), )),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width*0.3,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1,color: Color(0xfff7f7f7)))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width*0.15,
                              height: MediaQuery.of(context).size.width*0.15,
                              decoration: BoxDecoration(
                                color: Color(0xffeeeeee),
                                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.5,),),
                                ),
                              child: Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01), child:Image.network("http://14.48.175.177/theme/basic_app/img/app/my_icon01.png",)),
                              ),
                          Text("판매내역")
                        ],
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                    InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width*0.15,
                            height: MediaQuery.of(context).size.width*0.15,
                            decoration: BoxDecoration(
                              color: Color(0xffeeeeee),
                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.5,),),
                            ),
                            child: Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01), child:Image.network("http://14.48.175.177/theme/basic_app/img/app/my_icon02.png",)),
                          ),
                          Text("나의광고")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.08,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Color(0xfff7f7f7)))
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.1,
                        height: MediaQuery.of(context).size.width*0.1,
                        child: Image.network("http://14.48.175.177/theme/basic_app/img/app/myul_icon01.png"),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                      Text("나의 위치 설정",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)

                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(
                      builder:(context) => location()
                  ));
                },
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.08,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Color(0xfff7f7f7)))
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.1,
                        height: MediaQuery.of(context).size.width*0.1,
                        child: Image.network("http://14.48.175.177/theme/basic_app/img/app/myul_icon02.png"),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                      Text("숲마켓 공유",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)

                    ],
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.08,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Color(0xfff7f7f7)))
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.1,
                        height: MediaQuery.of(context).size.width*0.1,
                        child: Image.network("http://14.48.175.177/theme/basic_app/img/app/myul_icon03.png"),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                      Text("공지사항",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)

                    ],
                  ),

                ),
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.08,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Color(0xfff7f7f7)))
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.1,
                        height: MediaQuery.of(context).size.width*0.1,
                        child: Image.network("http://14.48.175.177/theme/basic_app/img/app/myul_icon04.png"),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                      Text("숲마켓 공유",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)

                    ],
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.08,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Color(0xfff7f7f7)))
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.1,
                        height: MediaQuery.of(context).size.width*0.1,
                        child: Image.network("http://14.48.175.177/theme/basic_app/img/app/myul_icon05.png"),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                      Text("앱 설정",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)

                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(
                      builder:(context) => mysetting()
                  ));
                },
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.08,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Color(0xfff7f7f7)))
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.1,
                        height: MediaQuery.of(context).size.width*0.1,
                        child: Image.network("http://14.48.175.177/theme/basic_app/img/app/myul_icon06.png"),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                      Text("로그 아웃",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),)

                    ],
                  ),
                ),
                onTap: (){
                  _showDialog();
                },
              ),
            ],
          ),
      ),

    );
  }
}
