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
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.06,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
              decoration: BoxDecoration(
                  color: Color(0xfff7f7f7),
                  border: Border.all(width: 1,color: Color(0xffdddddd))
              ),
                child: TextField(
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height*0.02,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only( left: 20),
                  ),
              ),
            )
          ],
        ),

      ),

    );
  }
}
