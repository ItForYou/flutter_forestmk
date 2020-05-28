import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterforestmk/basic_item.dart';
import 'package:flutterforestmk/basicview.dart';
import 'package:flutterforestmk/my_items.dart';
import 'package:http/http.dart' as http;

class basicboard extends StatefulWidget {

  final String title, bo_table,mb_id;
  basicboard({Key key, this.title,@required this.bo_table, this.mb_id}) : super(key: key);

  @override
  _basicboardState createState() => _basicboardState();
}

class _basicboardState extends State<basicboard> {

   // List <bool> chebkbox_wr = [];
   Widget widget_writes;

    var itemdata;

   void get_writes(size){
        List <Widget> temp_list = [];
        Widget total_widget =  Container(

              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.025,
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05),
              child: Align(alignment:Alignment.bottomRight,child: Text("Total "+itemdata['data'].length.toString()+"건",style: TextStyle(color: Color(0xff888888)),)),
            );
        temp_list.add(total_widget);
     List <bool> chebkbox_wr = [];

        if(size>0) {
          for (int i = 0; i < size; i++) {

            var temp_data = basic_item.fromJson(itemdata['data'][i]);

            if (chebkbox_wr.length <= i) {
              chebkbox_wr.add(false);
            }

            Widget temp_widget = Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.08,
                decoration:BoxDecoration(
                  border: Border(top:BorderSide(width: 1,color: Color(0xfff3f3f3)))
                ),
                child: Row(
                  children: <Widget>[
                    widget.mb_id=='admin'?
                    Checkbox(
                      value: chebkbox_wr[i],
                      onChanged: (bool value) {
                        setState(() {
                          chebkbox_wr[i] = value;
                        });
                      },
                    ):SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                    InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.title, style: TextStyle(fontSize: MediaQuery
                              .of(context)
                              .size
                              .width * 0.04),),
                          SizedBox(height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.005,),
                          Text(temp_data.mb_name+" | "+temp_data.wr_datetime.substring(5,10)+" | 조회 "+temp_data.wr_hit)
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                basicview(title: widget.title,)
                        ));
                      },
                    )
                  ],
                )
            );
            temp_list.add(temp_widget);
          }
          widget_writes = ListView(
            children: temp_list,
          );
        }
        else {
          widget_writes = Container(
              width:MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.1,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 1, color: Color(0xfff3f3f3)), bottom: BorderSide(width: 1, color: Color(0xfff3f3f3)))
              ),
              child: Center(child: Text("등록된 글이 없습니다.")));
        }
        setState(() {
        });
  }

    Future<dynamic> get_data() async{

      final response = await http.post(
          Uri.encodeFull("http://14.48.175.177/get_boardwr.php"),
          body: {
            "bo_table" : widget.bo_table,
            "mb_id":widget.mb_id==null?'':widget.mb_id,
          },
          headers: {'Accept' : 'application/json'}
      );

      itemdata = jsonDecode(response.body);
      //print(itemdata['data'][0]);
      setState(() {
        get_writes(itemdata['data'].length);
      });
    }
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: widget_writes,
      floatingActionButton: Container(
        margin: EdgeInsets.only(top : (widget.mb_id=='admin')||(widget.mb_id=='lets080')?MediaQuery.of(context).size.height*0.85:MediaQuery.of(context).size.height*0.9,),
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              (widget.mb_id=='admin')||(widget.mb_id=='lets080')?
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

              ):Container(),
              (widget.mb_id=='admin')||(widget.mb_id=='lets080')?
              SizedBox(height: MediaQuery.of(context).size.height*0.01,):Container(),
              ((widget.title=='공지사항')&&((widget.mb_id=='admin')||(widget.mb_id=='lets080')))||(widget.title=='고객문의')?
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
                    ),)):Container(),
            ],
          ),
          onTap: (){

          },
        ),
      ),
    );

  }
}
