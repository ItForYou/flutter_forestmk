import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterforestmk/main_item.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kopo/kopo.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class write_ad extends StatefulWidget {

  final String wr_id;
  final main_item info;
  write_ad({Key key, this.info, this.wr_id}) : super(key: key);

  @override
  writead_State createState() => writead_State();
}

class writead_State extends State<write_ad> {

  TextEditingController input_subject = new TextEditingController();
  TextEditingController input_content = new TextEditingController();
  TextEditingController input_wr_5 = new TextEditingController();

  Color color_cate = Color(0xffdddddd);
  List<Widget> image_boxes = List<Widget>();
  List<File> Images = [];
  int first_build =1;
  double grid_height;
  String str_address ="주소를 입력해주세요";
  String mb_id,mb_name,mb_5,mb_6,wr_6='미승인';
  List <int> select_days=[7,14,21,28];
  List<String> modify_imges= [];
  List <Color> select_bgcolors=[Colors.forestmk,Colors.white,Colors.white,Colors.white];
  List <Color> select_txtcolors=[Colors.white,Colors.black,Colors.black,Colors.black];
  int selected_day=7;
  var itemdata_now;

  Widget get_Imagebox(File image) {

    int  flg_int = image_boxes.length;

    Container imagebox = Container(
      child: Stack(
        children: <Widget>[
          Image.file(image),
          Positioned(
            top: 0, right: 0,
            child: Container(
                width: MediaQuery.of(context).size.width*0.05,
                height: MediaQuery.of(context).size.height*0.02,
                child:InkWell(
                  child:Image.asset("images/fa-times-circle.png"),
                  onTap: (){
                        setState(() {
                              Images.removeAt(flg_int);
                              image_boxes.clear();
                              for(int i=0; i<Images.length; i++){
                                image_boxes.add(get_Imagebox(Images[i]));
                              }
                              image_boxes.add(get_addbox());


                              if(Images.length >3 && Images.length <=7){
                                grid_height = MediaQuery.of(context).size.height*0.21;
                              }
                              else if(Images.length >7){
                              grid_height = MediaQuery.of(context).size.height*0.31;
                              }
                              else{
                                grid_height = MediaQuery.of(context).size.height*0.1;
                              }
                        });
                  },
                )
            ),
          )
        ],
      ),
    );
    return imagebox;
  }

  Widget get_addbox(){
    Widget temp  = InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffcccccc)),
            borderRadius: BorderRadius.circular(MediaQuery
                .of(context)
                .size
                .width * 0.015)
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.all(MediaQuery
                    .of(context)
                    .size
                    .width * 0.06,),
                child: Image.asset(
                    "images/fa-plus.png"),
              ),
            ),
            Positioned(
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.005,
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.045,
              child: RichText(
                      text: TextSpan(
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03,
                          color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: "("),
                          TextSpan(text:(image_boxes.length+1).toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, color:Colors.forestmk)),
                          TextSpan(text: "/10)")
                        ]
                ),
              ),
            )
          ],
        ),
      ),
      onTap: (){
        getGalleryImage();
      },
    );

    return temp;
  }

  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.getString('id')!=null) {
      mb_id = sp.getString('id');
      get_mbdata();
    }
  }

  Future<dynamic> get_mbdata() async{

    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_mb.php'),
        body: {
          "mb_id":mb_id==null?'':mb_id,
        },
        headers: {'Accept' : 'application/json'}
    );
    //print(jsonDecode(response.body));

    var temp_mbdata = jsonDecode(response.body);
    mb_name = temp_mbdata['mb_name'];
    mb_5 = temp_mbdata['mb_5'];
    mb_6 = temp_mbdata['mb_6'];
  }

  Widget get_Imagebox2(image) {
    first_build =0;
    int  flg_int = image_boxes.length;

    Container imagebox = Container(
      child: Stack(
        children: <Widget>[
          Image.network(image),
          Positioned(
            top: 0, right: 0,
            child: Container(
                width: MediaQuery.of(context).size.width*0.05,
                height: MediaQuery.of(context).size.height*0.02,
                child:InkWell(
                  child:Image.asset("images/fa-times-circle.png"),
                  onTap: (){

                    setState(() {
                      modify_imges.removeAt(flg_int);
                      image_boxes.clear();
                      for(int i=0; i<modify_imges.length; i++){
                        image_boxes.add(get_Imagebox2(modify_imges[i]));
                      }
                      for(int i=0; i<Images.length; i++){
                        image_boxes.add(get_Imagebox(Images[i]));
                      }
                      image_boxes.add(get_addbox());


                      if(image_boxes.length >3 && image_boxes.length <=7){
                        grid_height = MediaQuery.of(context).size.height*0.21;
                      }
                      else if(image_boxes.length >7){
                        grid_height = MediaQuery.of(context).size.height*0.31;
                      }
                      else{
                        grid_height = MediaQuery.of(context).size.height*0.1;
                      }
                    });
                  },
                )
            ),
          )
        ],
      ),
    );
    return imagebox;
  }

  Future<String> uploaddata() async {

    ProgressDialog pr = ProgressDialog(
        context,
        isDismissible: false,
    );
    //pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: '잠시만 기다려주세요...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: Container(padding:EdgeInsets.all(MediaQuery.of(context).size.height * 0.014),child: CircularProgressIndicator()),
      elevation: 5.0,
      messageTextStyle: TextStyle(
        color: Colors.black, fontSize: MediaQuery.of(context).size.height * 0.018,),
      insetAnimCurve: Curves.easeInOut,
    );
    pr.show();



    var request = http.MultipartRequest('POST', Uri.parse("http://14.48.175.177/insert_writedeal.php"));

    request.fields['wr_subject'] = input_subject.text;
    request.fields['wr_content'] = input_content.text;

    if(modify_imges.length>0) {
      for (int i = 0; i < modify_imges.length; i++) {
        request.fields['before_files[' + i.toString() + ']'] =
            modify_imges[i].substring(36);
      }
    }
    else{
      request.fields['before_files[0]'] ='';
    }
    if(widget.info!=null){
      request.fields['wr_id'] = widget.info.wr_id;
      request.fields['w'] = 'u';
    }
    else if(widget.wr_id!=null){
      request.fields['wr_id'] = widget.wr_id;
      request.fields['w'] = 'u';
    }

    request.fields['ca_name'] = '업체';
    request.fields['mb_id'] = mb_id;
    request.fields['mb_name'] = mb_name;
    request.fields['wr_11'] = str_address;
    request.fields['wr_5'] = input_wr_5.text;
    request.fields['wr_6'] = wr_6;
    request.fields['wr_7'] = selected_day.toString();
    request.fields['wr_2'] = '업체';
    request.fields['wr_file'] = (Images.length+modify_imges.length).toString();


    if (Images.length >0) {

      for(int i=0; i<Images.length; i++) {
        //print("upload"+ i.toString());
        request.files.add(await http.MultipartFile.fromPath('bf_file['+i.toString()+']', Images[i].path));
      }
    }

    var res = await request.send();
    if (res.statusCode == 200) {
      //return res.stream.bytesToString();
      if(widget.info==null)
      Navigator.pop(context);

      Navigator.pop(context);
      Navigator.pop(context,"success");
    }
  }

  void change_days(index){
    setState(() {
      if(select_bgcolors[index]==Colors.white)
        select_bgcolors[index] = Colors.forestmk;
      else
        select_bgcolors[index] = Colors.white;

      if(select_txtcolors[index]==Colors.black)
        select_txtcolors[index] = Colors.white;
      else
        select_txtcolors[index] = Colors.black;

      for(int i =0; i<4; i++){
        if(i==index)
          continue;
        select_bgcolors[i] = Colors.white;
        select_txtcolors[i] = Colors.black;
      }
      selected_day = select_days[index];
    });

  }

  getGalleryImage() async {

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(first_build==1) {
        first_build = 0;
        Images.add(image);
        image_boxes.clear();
        image_boxes.add(get_Imagebox(image));
        if(Images.length <10)
        image_boxes.add(get_addbox());
      }
      else{
        Images.add(image);
        image_boxes.removeLast();
        image_boxes.add(get_Imagebox(image));

        if(Images.length <10)
          image_boxes.add(get_addbox());

        if(Images.length >3 && Images.length <=7){
          grid_height = MediaQuery.of(context).size.height*0.21;
        }
        else if(Images.length >7){
          grid_height = MediaQuery.of(context).size.height*0.31;
        }
      }
    });
  }

  Future<dynamic> get_data_now() async{
    final response = await http.post(
        Uri.encodeFull('http://14.48.175.177/get_viewwr.php'),
        body: {
          "wr_id" :widget.wr_id,
        },
        headers: {'Accept' : 'application/json'}
    );
    setState(() {

      itemdata_now = jsonDecode(response.body);
      input_content.text = itemdata_now['wr_content'];
      input_subject.text = itemdata_now['wr_subject'];

    });
  }

  void show_exit() {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context2).size.height*0.032,
            child: Text(widget.info==null?"글쓰기를 종료 하시겠습니까?":"수정을 종료 하시겠습니까?"),
          ),
          actions: <Widget>[

            new FlatButton(
              child: new Text("취소", style: TextStyle(color: Colors.red),),
              onPressed: (){
                Navigator.of(context2).pop(true);
              },
            ),
            new FlatButton(
              child: new Text("확인", style: TextStyle(color: Colors.forestmk),),
              onPressed: (){
                if(widget.info!=null)
                  Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
                Navigator.of(context2).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_myinfo();

    if(widget.info!=null){

      input_content.text = widget.info.wr_content;
      input_subject.text = widget.info.wr_subject;
      input_wr_5.text = widget.info.wr_5;
      color_cate = Colors.black;
      str_address = widget.info.wr_11;
      wr_6 = widget.info.wr_6;

    }

    else if(widget.info==null && widget.wr_id!=null){

      get_data_now();

    }

  }

  @override
  Widget build(BuildContext context) {

    if(widget.info!=null && first_build ==1&&widget.info.file[0]!='nullimage'){

      modify_imges.clear();
      for(int i=1; i<widget.info.file.length; i++) {
        if(widget.info.file.length-1 >3 && widget.info.file.length-1 <=7){
          grid_height = MediaQuery.of(context).size.height*0.21;
        }
        else if(widget.info.file.length-1 >7){
          grid_height = MediaQuery.of(context).size.height*0.31;
        }
        else{
          grid_height = MediaQuery.of(context).size.height*0.1;
        }
        modify_imges.add(widget.info.file[i]);
        image_boxes.add(get_Imagebox2(modify_imges[i-1]));
      }
      image_boxes.add(get_addbox());

    }

    else if(widget.info==null && first_build ==1 && widget.wr_id !=null && itemdata_now!=null){

      modify_imges.clear();
      image_boxes.clear();
      for(int i=0; i<itemdata_now['files'].length; i++) {
        if(itemdata_now['files'].length-1 >3 && itemdata_now['files'].length-1 <=7){
          grid_height = MediaQuery.of(context).size.height*0.21;
        }
        else if(itemdata_now['files'].length-1 >7){
          grid_height = MediaQuery.of(context).size.height*0.31;
        }
        else{
          grid_height = MediaQuery.of(context).size.height*0.1;
        }
        modify_imges.add(itemdata_now['files'][i]);
        image_boxes.add(get_Imagebox2(itemdata_now['files'][i]));
      }
      image_boxes.add(get_addbox());

    }

    if(first_build ==1 && image_boxes.length <=0){
      grid_height = MediaQuery.of(context).size.height*0.1;
      image_boxes.add(get_addbox());
    }
    /*if(image_boxes.length < 10) {
      image_boxes.add(get_addbox());
    }*/

    return WillPopScope(
      onWillPop: (){
        show_exit();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height*0.07),
          child: AppBar(
            title: Text(widget.info==null?"광고업체 글쓰기":"광고업체 글쓰기 수정" ,style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: InkWell(
              child:Padding(
                  padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.02, bottom: MediaQuery.of(context).size.height*0.02, left: MediaQuery.of(context).size.width*0.05),
                  child:Image.asset("images/hd_back.png")
              ),
              onTap: (){
                show_exit();
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.06,
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Text("홍보 사진 첨부", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,),),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          width: MediaQuery.of(context).size.width*0.85,
                          height: grid_height,
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,right: MediaQuery.of(context).size.width*0.05),
                          color: Colors.white,
                          child:GridView.builder(

                              itemCount: image_boxes.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                              ),
                              itemBuilder: (BuildContext context, int index){
                                return image_boxes[index];
                              }
                          )
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.05,
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("주소",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,)),
                           InkWell(
                             child: Container(
                                  width: MediaQuery.of(context).size.width*0.7,
                                  height: MediaQuery.of(context).size.height*0.05,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1.5,
                                              color: Color(0xfff7f7f7)
                                          )
                                      )
                                  ),
                                  child: Center(
                                    child: Container(
                                        width: MediaQuery.of(context).size.width*0.7,
                                        child:Text(str_address,style: TextStyle(color: color_cate,fontSize: MediaQuery.of(context).size.width*0.038,),textAlign: TextAlign.start,)
                                    ),
                                  )
                              ),
                             onTap: ()async {
                               KopoModel model = await Navigator.push(
                                 context,
                                 CupertinoPageRoute(
                                   builder: (context) => Kopo(),
                                 ),
                               );
                               setState(() {
                                 color_cate=Colors.black;
                                 str_address = '${model.sido} ${model.sigungu} ${model.bname}';//'${model.address}';
                               });
                             },
                           )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.05,
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("전화번호",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,)),
                          Container(
                              width: MediaQuery.of(context).size.width*0.7,
                              height: MediaQuery.of(context).size.height*0.05,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.5,
                                          color: Color(0xfff7f7f7)
                                      )
                                  )
                              ),
                              child: Container(
                                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.15,),
                                child:TextField(
                                  controller: input_wr_5,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "전화번호를 입력하세요",
                                    hintStyle: TextStyle(color: Color(0xffdddddd),fontSize: MediaQuery.of(context).size.width*0.038)
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.05,
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("업체이름",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,)),
                          Container(
                              width: MediaQuery.of(context).size.width*0.7,
                              height: MediaQuery.of(context).size.height*0.05,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.5,
                                          color: Color(0xfff7f7f7)
                                      )
                                  )
                              ),
                              child: Container(
                                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.15,),
                                child:TextField(
                                  controller: input_subject,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "업체이름을 입력하세요",
                                    hintStyle: TextStyle(color: Color(0xffdddddd), fontSize: MediaQuery.of(context).size.width*0.038)
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.05,
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("내용",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,)),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.98,
                      height: MediaQuery.of(context).size.height*0.4,

                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1, color: Color(0xfff7f7f7))
                      ),
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,right: MediaQuery.of(context).size.width*0.05,
                        top: MediaQuery.of(context).size.width*0.01,bottom: MediaQuery.of(context).size.width*0.085,),
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01),
                      child: TextField(
                        controller: input_content,
                        maxLines: null,
                        cursorColor: Color(0xff9dc543),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "홍보 내용을 입력해주세요",
                            hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.038,color:Color(0xffdddddd) )
                        ),
                      ),
                    ),
              /*Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.05,
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("광고게제 일수",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,)),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.07,
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05),
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02,),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.height*0.11,
                          height: MediaQuery.of(context).size.height*0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.02)),
                              color: select_bgcolors[0],
                              border: Border.all(width: 1, color: Color(0xfff3f3f3))
                          ),
                          child: Center(child: Text("7일", style: TextStyle(color: select_txtcolors[0]),)),
                        ),
                        onTap: (){
                          change_days(0);
                        },
                      ),
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.height*0.11,
                          height: MediaQuery.of(context).size.height*0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.02)),
                              color: select_bgcolors[1],
                              border: Border.all(width: 1, color: Color(0xfff3f3f3))
                          ),
                          child: Center(child: Text("14일", style: TextStyle(color: select_txtcolors[1]),)),
                        ),
                        onTap: (){
                          change_days(1);
                        },
                      ),
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.height*0.11,
                          height: MediaQuery.of(context).size.height*0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.02)),
                              color: select_bgcolors[2],
                              border: Border.all(width: 1, color: Color(0xfff3f3f3))
                          ),
                          child: Center(child: Text("21일", style: TextStyle(color: select_txtcolors[2]),)),
                        ),
                        onTap: (){
                          change_days(2);
                        },
                      ),
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.height*0.11,
                          height: MediaQuery.of(context).size.height*0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.02)),
                              color: select_bgcolors[3],
                              border: Border.all(width: 1, color: Color(0xfff3f3f3))
                          ),
                          child: Center(child: Text("28일", style: TextStyle(color: select_txtcolors[3]),)),
                        ),
                        onTap: (){
                          change_days(3);
                        },
                      )
                    ],
                  ),
              ),*/

              InkWell(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.075,
                    color: Colors.grey,
                    child: Center(child: Text("등록하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.055, color: Colors.white,)),
                    )
                ),
                onTap: ()async{
                  var result  =  await uploaddata();
                  print(result);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
