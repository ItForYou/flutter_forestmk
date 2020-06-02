
import 'package:flutter/material.dart';
import 'package:flutterforestmk/basic_item.dart';
import 'package:http/http.dart' as http;

class write_basic extends StatefulWidget {

  final String title, bo_table,mb_id,mb_name,w;
  final basic_item info;
  write_basic({Key key, this.title,@required this.bo_table, this.mb_name,this.mb_id, this.info, this.w}) : super(key: key);

  @override
  _write_basicState createState() => _write_basicState();
}



class _write_basicState extends State<write_basic> {

  TextEditingController input_wrsubject = new TextEditingController();
  TextEditingController input_wrcontent = new TextEditingController();


  Future<dynamic> uploaddata() async{
      //print(widget.mb_name);
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_basic.php'),
        body: {
          "wr_id":widget.info!=null?widget.info.wr_id:'',
          "mb_id":widget.mb_id==null?'':widget.mb_id,
          "bo_table":widget.bo_table==null?'':widget.bo_table,
          "wr_subject": input_wrsubject.text,
          "wr_content": input_wrcontent.text,
          "w":widget.w==null?'':widget.w
        },
        headers: {'Accept' : 'application/json'}
    );

    if(response.statusCode==200) {
      if (widget.w == 'u') {
        Navigator.pop(context);
        Navigator.pop(context,"delete");
      }
      else
        Navigator.pop(context, "success");
    }
  }

  @override
  void initState() {

    if(widget.info!=null && widget.w=='u'){
      input_wrsubject.text = widget.info.wr_subject;
      input_wrcontent.text = widget.info.wr_content;
    }
    // TODO: implement initState
    super.initState();

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
              child:Image.asset("images/hd_back.png")
          ),
          onTap: (){
            Navigator.of(context).pop(true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.06,

              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1,),
              child:  TextFormField(
                  controller: input_wrsubject,
                  cursorColor: Colors.forestmk,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Color(0xffefefef))
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Color(0xffefefef))
                      ),

                      hintText: "제목을 입력해주세요",
                      hintStyle: TextStyle(fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.038,color: Color(0xffd9d9d9))
                  ),
                  onChanged: (value) async{

                  }
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.4,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Color(0xfff0f0f0)))
              ),
              child:TextFormField(
                  controller: input_wrcontent,
                  cursorColor: Colors.forestmk,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "내용을 입력해주세요",
                      hintStyle: TextStyle(fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.038,color: Color(0xffd9d9d9))
                  ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.35,),
            InkWell(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.075,
                  color: Colors.grey,
                  child: Center(child: Text("등록하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.055, color: Colors.white,)),
                  )
              ),
              onTap: (){
                uploaddata();
              },
            )


          ],
        ),
      ),
    );
  }
}
