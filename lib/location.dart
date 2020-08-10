
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class location  extends StatefulWidget {
  String mb_name,mb_1,mb_2,mb_3,mb_4,mb_5,mb_6,mb_hp,mb_id;
  location({Key key, this.mb_name, this.mb_1, this.mb_2,this.mb_6,this.mb_5,this.mb_4,this.mb_3,this.mb_hp,this.mb_id}) : super(key: key);

  @override
  location_State createState() => location_State();
}

class location_State extends State<location> {

  TextEditingController now_mylocation = TextEditingController();
  TextEditingController search_location = TextEditingController();
  List <Widget> searchaddr_widgets = [Container()];
  var itemdata;


  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.getString('id')!=null) {
      widget.mb_id = sp.getString('id');
    }
  }

  Future<dynamic> get_data(value) async {
    searchaddr_widgets.clear();
    Widget temp = Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.05,
        margin: EdgeInsets.only(top: MediaQuery
            .of(context)
            .size
            .height * 0.03,),
        padding: EdgeInsets.only(left: MediaQuery
            .of(context)
            .size
            .width * 0.05),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1, color: Color(0xfff3f3f3)))
        ),
        child: Text("'" + value + "'검색결과", style: TextStyle(fontSize: MediaQuery
            .of(context)
            .size
            .width * 0.04,))
    );
    searchaddr_widgets.add(temp);

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/search_location.php'),
        body: {
          "value": value
        },
        headers: {'Accept': 'application/json'}
    );
    // print(response.body);
    setState(() {
      itemdata = jsonDecode(response.body);

      get_locatoinwidget();
    });
  }

  Future<dynamic> update_location(value) async {


    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/update_location.php'),
        body: {
          "mb_id": widget.mb_id,
          "value": value
        },
        headers: {'Accept': 'application/json'}
    );
    // print(response.body);
    if(response.statusCode==200){
      Navigator.pop(context,"change");
    }
}

  Widget get_locatoinwidget(){

    if(itemdata['data'].length>0) {
      for (int i = 0; i < itemdata['data'].length; i++) {
        Widget temp = InkWell(
          child:Container(
            margin: EdgeInsets.only(top:MediaQuery
                .of(context)
                .size
                .height * 0.02,),
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.05,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1,color: Color(0xfff3f3f3)))
            ),
            child: Text(itemdata['data'][i], style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.04),),
          ),
          onTap: (){
            update_location(itemdata['data'][i]);
          },
        );
        searchaddr_widgets.add(temp);
      }
    }
    else {
      searchaddr_widgets.clear();
    }

  }

  void show_Alert(text,flg) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
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
              onPressed: ()async{
                if(flg ==2){
                  Navigator.of(context).pop(true);
                  Navigator.of(context2).pop(true);
                }
                else{
                  Navigator.of(context2).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void get_location() async{

    bool geolocationStatus  = await Geolocator().isLocationServiceEnabled();

    if(geolocationStatus==true) {
      ProgressDialog pr = ProgressDialog(context);
      //pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
      pr.style(
        message: '잠시만 기다려주세요...',
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        progressWidget: Container(padding: EdgeInsets.all(MediaQuery
            .of(context)
            .size
            .height * 0.014), child: CircularProgressIndicator()),
        elevation: 5.0,
        messageTextStyle: TextStyle(
          color: Colors.black, fontSize: MediaQuery
            .of(context)
            .size
            .height * 0.018,),
        insetAnimCurve: Curves.easeInOut,
      );
      pr.show();

      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (position != null) {
        final response = await http.post(
            Uri.encodeFull('http://14.48.175.177/get_current.php'),
            body: {
              "x": position.longitude.toString(),
              'y': position.latitude.toString()
            },
            headers: {'Accept': 'application/json'}
        );

        if (response.statusCode == 200) {
          Navigator.pop(context);
          // print(jsonDecode(response.body));
          var json_address = jsonDecode(response.body);
          String address = json_address['documents'][0]['address']['region_1depth_name'] +
              " " +
              json_address['documents'][0]['address']['region_2depth_name'] +
              " " +
              json_address['documents'][0]['address']['region_3depth_name'];
          //print(address);
          update_location(address);
        }
      }
    }
    else{
      show_Alert("위치기능을 켜주세요", 1);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    now_mylocation.text = widget.mb_2;
    load_myinfo();
    super.initState();

  }
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
              padding: EdgeInsets.all(13),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width*0.16,
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                      child: Text("설정 위치 :")
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    height: MediaQuery.of(context).size.height*0.07,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.003, right: MediaQuery.of(context).size.width*0.05),
                    child: TextFormField(
                        readOnly: true,
                        controller: now_mylocation,
                        onChanged: (value){
                          get_data(value);
                        },
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
                ],
              ),
              SizedBox(height:MediaQuery.of(context).size.height*0.05),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right:  MediaQuery.of(context).size.width*0.05,),
                child: TextFormField(
                  onChanged: (value){
                    get_data(value);
                  },
                  controller: search_location,
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
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.height*0.05,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.015,),
                  decoration: BoxDecoration(
                      color: Colors.forestmk,
                      borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.07))
                  ),
                  child: Center(child: Text("현재위치로 찾기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color: Colors.white))),
                ),
                onTap: (){
                  get_location();
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: searchaddr_widgets,
              )
            ],
        ),
      ),

    );
  }
}
