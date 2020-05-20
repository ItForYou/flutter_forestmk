import 'package:flutter/material.dart';
import 'package:flutterforestmk/basicview.dart';

class basicboard extends StatefulWidget {

  final String title;

  basicboard({Key key, this.title,}) : super(key: key);

  @override
  _basicboardState createState() => _basicboardState();
}

class _basicboardState extends State<basicboard> {

    List <bool> chebkbox_wr = [];

    List <Widget> get_writes(){

        List <Widget> temp = [];
        for(int i=0; i<15; i++){
          if(chebkbox_wr.length <=15){
            chebkbox_wr.add(false);
          }
      Widget temp_widget = Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.08,
        child: Row(
          children: <Widget> [
            Checkbox(
              value: chebkbox_wr[i],
              onChanged: (bool value){
                setState(() {
                  chebkbox_wr[i]=value;
                });
              },
            ),
            InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.title,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),),
                  SizedBox(height: MediaQuery.of(context).size.height*0.005,),
                  Text("테스트 | 05-15 | 조회 1")
                ],
              ),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(
                    builder:(context) => basicview(title: widget.title,)
                ));
              },
            )
          ],
        )
      );
      temp.add(temp_widget);
    }
    return temp;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ,style: TextStyle(color: Colors.black),),
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
      body: ListView(
          children: get_writes(),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(top : MediaQuery.of(context).size.height*0.85,),
        child: InkWell(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.07,
                child: FloatingActionButton(
                    heroTag: null,
                    onPressed: null,
                    backgroundColor: Color(0xff211a2c),
                    child: Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.015,),
                        child: Image.asset("images/fa-trash.png")
                    ),
                ),

              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),
              Container(
                  height: MediaQuery.of(context).size.height*0.07,
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: null,
                    backgroundColor: Colors.forestmk,
                    child:
                    Padding(
                      padding:  EdgeInsets.all(MediaQuery.of(context).size.height*0.01,),
                      child: Image.asset("images/fa-plus-w.png"),
                    ),)),
            ],

          ),
          onTap: (){

          },
        ),
      ),
    );

  }
}
