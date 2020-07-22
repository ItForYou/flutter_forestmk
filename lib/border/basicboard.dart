import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterforestmk/border/basic_item.dart';
import 'package:flutterforestmk/border/basicview.dart';
import 'package:flutterforestmk/member/my_items.dart';
import 'package:flutterforestmk/border/write_basic.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class basicboard extends StatefulWidget {

  final String title, bo_table,mb_id,mb_name;
  basicboard({Key key, this.title,@required this.bo_table, this.mb_name, this.mb_id}) : super(key: key);

  @override
  _basicboardState createState() => _basicboardState();
}

class _basicboardState extends State<basicboard> {
  RefreshController _refreshController =  RefreshController(initialRefresh: false);
   // List <bool> chebkbox_wr = [];
   Widget widget_writes;
   List <bool> checkbox_values;
    var itemdata;

   void show_Alert(text,flg) {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         // return object of type Dialog
         return AlertDialog(
           title:null,
           content: Container(
             height: MediaQuery.of(context).size.height*0.03,
             child: Text(text),
           ),
           actions: <Widget>[
             new FlatButton(
               child: new Text("확인"),
               onPressed: (){
                 if(flg ==2)
                   Navigator.of(context).pop(true);
                 Navigator.of(context).pop(true);
               },
             ),
           ],
         );
       },
     );
   }

   void show_delete() {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         // return object of type Dialog
         return AlertDialog(
           title:null,
           content: Container(
             height: MediaQuery.of(context).size.height*0.05,
             child: Text("한번 삭제한 자료는 복구할 방법이 없습니다.\n선택한 게시물을 정말 삭제하시겠습니까?"),
           ),
           actions: <Widget>[

             new FlatButton(
               child: new Text("취소",style: TextStyle(color: Colors.red),),
               onPressed: () {
                 Navigator.pop(context);
               },
             ),
             new FlatButton(
               child: new Text("확인",style: TextStyle(color: Colors.forestmk),),
               onPressed: ()async{
                 var result = await delete_data(context);
                 print(result);
               },
             ),
           ],
         );
       },
     );
   }

   Future<dynamic> delete_data(popcontext) async{

     List <String> checked_id=[];
     for(int i=0; i<checkbox_values.length; i++){
       if(checkbox_values[i] == true)
         checked_id.add(itemdata['data'][i]['wr_id']);
     }

     if(checked_id.length<=0){
       return;
     }

     var request = http.MultipartRequest('POST', Uri.parse("http://14.48.175.177/delete_board.php"));

     request.fields['bo_table'] = widget.bo_table;
     for(int i=0; i<checked_id.length; i++){
       request.fields['wr_id['+i.toString()+']'] = checked_id[i];
     }

     var res = await request.send();
     if (res.statusCode == 200) {
       // return res.stream.bytesToString();
       setState(() {
         get_data();
         Navigator.pop(popcontext);
       });
     }

   }


  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 800));
    // if failed,use refreshFailed()
      get_data();

    _refreshController.refreshCompleted();
  }

   void get_writes(size){
        List <Widget> temp_list = [];
        Widget total_widget =  Container(

              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.025,
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05),
              child: Align(alignment:Alignment.bottomRight,child: Text("Total "+itemdata['data'].length.toString()+"건",style: TextStyle(color: Color(0xff888888)),)),
            );
        temp_list.add(total_widget);

        if(size>0) {
          for (int i = 0; i < size; i++) {

            var temp_data = basic_item.fromJson(itemdata['data'][i]);

            Widget temp_widget = InkWell(
                child:Container(
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
                      value: checkbox_values[i],
                      onChanged: (bool value) {
                        setState(() {
                          checkbox_values[i] = value;
                          get_writes(itemdata['data'].length);
                        });
                      },
                    ):SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            temp_data.wr_subject, style: TextStyle(fontSize: MediaQuery
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

                  ],
                )
            ),
              onTap: () async{
                var result = await Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>  basicview(title: widget.title, item: temp_data,bo_table: widget.bo_table,mb_id:widget.mb_id, mb_name:widget.mb_name)
                ));
                if(result == 'delete'){
                  get_data();
                }
              },
            );
            temp_list.add(temp_widget);
          }
          widget_writes = SmartRefresher(
            enablePullDown: true,
            header: MaterialClassicHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView(
              children: temp_list,
            ),
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

      setState(() {

        checkbox_values = List<bool>(itemdata['data'].length);
        for(int i=0; i< itemdata['data'].length; i++){
          checkbox_values[i] = false;
        }
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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              (widget.mb_id=='admin')||(widget.mb_id=='lets080')?
              InkWell(
                child: Container(
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
                onTap: (){
                  if(checkbox_values.contains(true))
                  show_delete();
                  else{
                    show_Alert("선택된 항목이 없습니다.", 1);
                  }
                },
              ):Container(),
              (widget.mb_id=='admin')||(widget.mb_id=='lets080')?
              SizedBox(height: MediaQuery.of(context).size.height*0.01,):Container(),
              ((widget.title=='공지사항')&&((widget.mb_id=='admin')||(widget.mb_id=='lets080')))||(widget.title=='고객문의')?
              InkWell(
                child: Container(
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
                onTap: ()async{
                  var result = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => write_basic(title:widget.title+" 글쓰기", bo_table: widget.bo_table, mb_id: widget.mb_id, mb_name:widget.mb_name)
                  ));
                  if(result == 'success'){
                    get_data();
                  }
                },
              ):Container(),
            ],

          ),
           ),
    );

  }
}
