import 'package:flutter/material.dart';



class location  extends StatefulWidget {
  @override
  location_State createState() => location_State();
}

class location_State extends State<location> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("나의 메뉴" ,style: TextStyle(color: Colors.black),),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.4,
        color: Colors.white,
        child: Column(
          children: <Widget>[

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.07,
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05),
              child: TextFormField(
                  keyboardType: TextInputType.text,

                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                    filled: true,
                    fillColor: Color(0xfff5f5f5),
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
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right:  MediaQuery.of(context).size.width*0.05,),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1,color: Color(0xffefefef))
                  ),
                  enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1,color: Color(0xffefefef))
                    ),
                  prefixIcon: Icon(Icons.search),
                  hintText: "내 동네 이름(동,읍,면)으로 검색"

                ),
              ),
              ),
            Container(
              width: MediaQuery.of(context).size.width*0.9,
              height: MediaQuery.of(context).size.height*0.05,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.015,),
              decoration: BoxDecoration(
                  color: Colors.forestmk,
                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.07))
              ),
              child: Center(child: Text("현재위치로 찾기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color: Colors.white))),

            )
          ],
        ),

      ),

    );
  }
}
