import 'package:flutter/material.dart';


class changehp extends StatefulWidget {
  @override
  _changehpState createState() => _changehpState();
}

class _changehpState extends State<changehp> {
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
                    keyboardType: TextInputType.number,

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
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),
              Text("핸드폰 번호는 1회만 변경 가능합니다."),
            SizedBox(height: MediaQuery.of(context).size.height*0.03,),
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.045,
              decoration: BoxDecoration(
                color: Colors.forestmk,
                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.07,)),
              ),
              child: Center(child: Text("인증하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color: Colors.white),)),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.045,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
              decoration: BoxDecoration(
                color: Colors.forestmk,
                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.07,)),
              ),
              child: Center(child: Text("변경하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color: Colors.white),)),
            ),





          ],
      ),
    );
  }
}
