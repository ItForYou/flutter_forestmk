import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class mysetting extends StatefulWidget {
  @override
  _mysettingState createState() => _mysettingState();
}

class _mysettingState extends State<mysetting> {

  bool  switchvalue=true;

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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.08,
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03, top: MediaQuery.of(context).size.height*0.03),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Color(0xfff7f7f7)))
              ),
              child: Text("앱설정",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,),),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.08,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xfff7f7f7)))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("댓글, 채팅 알람",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,),),
                  Switch(
                    value: switchvalue,
                    onChanged: (value){
                      setState(() {
                        switchvalue = value;
                      });
                    },
                    activeTrackColor: Colors.forestmk,
                    activeColor: Colors.white,
                  )

                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.08,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xfff7f7f7)))
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.08,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xfff7f7f7)))
              ),
            ),Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.08,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xfff7f7f7)))
              ),
            ),

          ],
        ),
      ),
    );
  }
}
