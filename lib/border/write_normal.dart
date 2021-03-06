import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutterforestmk/main_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class write_normal extends StatefulWidget {
  final String wr_id;
  final main_item info;
  write_normal({Key key, this.info, this.wr_id}) : super(key: key);

  @override
  writenormal_State createState() => writenormal_State();
}

class writenormal_State extends State<write_normal> {

  TextEditingController input_subject = new TextEditingController();
  TextEditingController input_content = new TextEditingController();
  TextEditingController input_wr_1 =new TextEditingController();

  String cate_value ="카테고리를 선택해주세요";
  Color color_cate = Color(0xffdddddd);
  List<Widget> image_boxes = List<Widget>();
  List<File> Images = [];
  List<String> modify_imges= [];
  int first_build =1;
  double grid_height;
  String mb_id,mb_name,mb_5,mb_6;
  int click_upload =0;
  bool click_free=false,flg_enablewr1=true;
  var itemdata_now;

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

  void add_comma(value){

    //input_wr_1.addListener(listener)
    
    MoneyFormatterOutput  fmf = FlutterMoneyFormatter(amount: double.parse(value)).output;
    value=fmf.withoutFractionDigits.toString();

      input_wr_1.text=value;
      input_wr_1.selection = TextSelection.fromPosition(TextPosition(offset: value.length));


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

  Widget get_Imagebox(File image) {

    int  flg_int = image_boxes.length-modify_imges.length;
    print(flg_int);
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
                    setState((){

                      Images.removeAt(flg_int);
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

  List<Widget> get_allcateitem(context){

    List<Widget> items = List<Widget>();
    var menu_names = ["생활용품", "여성의류", "가구/인테리어", "여성잡화", "디지털/가전","남성의류", "자동차/오토바이","남성잡화",
      "게임/취미","유아용품","스포츠/레저","뷰티/미용","도서","반려동물용품","식품","건강/의료용품","기타물품","부동산",];
    var cnt;
    for(int i=0; i<menu_names.length; i++){

      String path_img;
      if((i+1)<10){
        path_img  = "0"+(i+1).toString();
      }
      else{
        path_img  = (i+1).toString();
      }
      InkWell temp =
          InkWell(
              child:Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.07,
                    padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.03,top: MediaQuery.of(context).size.height*0.01, bottom: MediaQuery.of(context).size.height*0.01,),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Color(0xfff7f7f7))
                      )
                    ),
                    child: Row(
                        children: <Widget>[
                          Image.asset("images/category"+path_img+".png"),
                          Text(menu_names[i],style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),)
                        ],
                    ),
                  ),
            onTap: (){
                setState(() {
                  cate_value = menu_names[i];
                  color_cate = Colors.black;
                  Navigator.pop(context);
                });
            },
          );
                  items.add(temp);
    }
    return items;
  }

  void show_catemd(){

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.02))
          ),
          title: null,
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            child: ListView(
              children: get_allcateitem(context),
            ),
          ),
          actions:null
        );
      },
    );
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
                  .width * 0.04,
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
      cate_value = itemdata_now['ca_name'];
      input_wr_1.text = itemdata_now['wr_1'];
    });
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

    if(click_upload==1){
      return '';
    }

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
    request.fields['ca_name'] = cate_value;
    request.fields['mb_id'] = mb_id;
    request.fields['mb_name'] = mb_name;
    request.fields['wr_1'] = input_wr_1.text;
    request.fields['wr_2'] = "일반";
    request.fields['wr_3'] = mb_5;
    request.fields['wr_4'] = mb_6;
    request.fields['wr_file'] = (Images.length+modify_imges.length).toString();

    if (Images.length >0) {
      for(int i=0; i<Images.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('bf_file['+i.toString()+']', Images[i].path));
      }
    }

    var res = await request.send();
    if (res.statusCode == 200) {
      //return res.stream.bytesToString();
        Navigator.pop(context);
        Navigator.pop(context,"success");
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
            child: Wrap(
                children: [
                  Text(text),
                ]),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: (){
                if(flg ==2)
                  Navigator.of(context).pop(true);
                Navigator.of(context2).pop(true);
              },
            ),
          ],
        );
      },
    );
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
            child: Text(widget.info!=null?"수정을 종료 하시겠습니까?":"글쓰기를 종료 하시겠습니까?"),
          ),
          actions: <Widget>[

            new FlatButton(
              child: new Text("취소",style: TextStyle(color: Colors.red),),
              onPressed: (){
                Navigator.of(context2).pop(true);
              },
            ),
            new FlatButton(
              child: new Text("확인", style: TextStyle(color: Colors.forestmk)),
              onPressed: (){
                Navigator.of(context2).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


 getGalleryImage() async {

   var image = await ImagePicker.pickImage(source: ImageSource.gallery);

   if(image!=null) {
     setState(() {
       if (first_build == 1) {
         first_build = 0;
         Images.add(image);
         image_boxes.clear();
         image_boxes.add(get_Imagebox(image));
         if (Images.length < 10)
           image_boxes.add(get_addbox());
       }
       else {
         Images.add(image);
         image_boxes.removeLast();
         image_boxes.add(get_Imagebox(image));

         if (image_boxes.length < 10)
           image_boxes.add(get_addbox());

         if (image_boxes.length > 3 && image_boxes.length <= 7) {
           grid_height = MediaQuery
               .of(context)
               .size
               .height * 0.21;
         }
         else if (image_boxes.length > 7) {
           grid_height = MediaQuery
               .of(context)
               .size
               .height * 0.31;
         }
       }
     });
   }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_myinfo();

    if(widget.info!=null){
      input_content.text = widget.info.wr_content;
      input_subject.text = widget.info.wr_subject;
      cate_value = widget.info.ca_name;
      color_cate = Colors.black;
      input_wr_1.text = widget.info.wr_1;
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
            title: Text(widget.info==null?"중고거래 글쓰기":"중고거래 글쓰기 수정" ,style: TextStyle(color: Colors.black87, fontSize: MediaQuery.of(context).size.width*0.045),),
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: InkWell(
              child:Padding(
                  padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.018, bottom: MediaQuery.of(context).size.height*0.018, left: MediaQuery.of(context).size.width*0.05),
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
                    height: MediaQuery.of(context).size.height*0.05,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                    color: Colors.white,
                    child: Row(
                        children: <Widget>[
                          Text("제품 사진 첨부", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,),),
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
                      height: MediaQuery.of(context).size.height*0.06,
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("카테고리",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,)),
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
                                     child:Text(cate_value,style: TextStyle(color: color_cate,fontSize: MediaQuery.of(context).size.width*0.04,),textAlign: TextAlign.start,)
                              ),
                               )
                            ),
                            onTap: (){
                              show_catemd();
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
                          Text("금액",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,)),

                          Row(
                            children: <Widget>[
                              Container(
                                    width: MediaQuery.of(context).size.width*0.5,
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
                                          child:TextField(
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter(RegExp('(^[+-]?\d+)(\d{3})')),
                                            ],
                                            keyboardType: TextInputType.number,
                                            controller: input_wr_1,
                                          //  onChanged: (value)=>add_comma(value),
                                            enabled: flg_enablewr1,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "금액을 입력해주세요",
                                              hintStyle: TextStyle(color:Color(0xffdddddd), fontSize: MediaQuery.of(context).size.width*0.04),
                                            ),
                                            ),
                                          )
                                      ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.2,
                                height: MediaQuery.of(context).size.height*0.05,
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.08,
                                      height: MediaQuery.of(context).size.height*0.05,
                                      decoration: BoxDecoration(
                                          border:Border(
                                              bottom: BorderSide(
                                                  width: 1.5,
                                                  color: Color(0xfff7f7f7)
                                              )
                                          )
                                      ),
                                      child: Checkbox(
                                        value: click_free,
                                        onChanged: (bool value){
                                          setState(() {
                                            //print("Check"+click_free.toString());
                                            if(value==true) {
                                              input_wr_1.text =
                                              "무료나눔";
                                            }
                                            else {
                                              input_wr_1.text = "";
                                            }
                                            click_free=value;
                                            flg_enablewr1 = !value;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.12,
                                      height: MediaQuery.of(context).size.height*0.05,
                                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.03),
                                      decoration: BoxDecoration(
                                          border:Border(
                                              bottom: BorderSide(
                                                  width: 1.5,
                                                  color: Color(0xfff7f7f7)
                                              )
                                          )
                                      ),
                                      child: Center(
                                        child: Text(
                                            "무료"
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.058,
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("제목",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,)),
                          Container(
                              width: MediaQuery.of(context).size.width*0.7,
                              height: MediaQuery.of(context).size.height*0.058,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.5,
                                          color: Color(0xfff7f7f7)
                                      )
                                  )
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.058,
                                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.15,),
                                child:TextField(
                                  controller: input_subject,
                                  cursorColor: Colors.black,
                                //  maxLength: 60,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(60),
                                  ],
                                  maxLengthEnforced: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                      hintText: "제목을 입력해주세요",
                                      hintStyle: TextStyle(color: Color(0xffdddddd),fontSize: MediaQuery.of(context).size.width*0.04),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.041,
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
                                              top: MediaQuery.of(context).size.width*0.01,bottom: MediaQuery.of(context).size.width*0.095,),
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01),
                      child: TextField(
                          controller:  input_content,
                          maxLines: null,
                          cursorColor: Color(0xff9dc543),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "내용을 입력해주세요",
                            hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,color: Color(0xffdddddd))
                        ),
                        ),
                    ),
                    InkWell(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.075,
                          color: Colors.grey,
                          child: Center(child: Text("등록하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.055, color: Colors.white,)),
                          )
                    ),
                      onTap: (){
                        if(input_subject.text!='' && input_subject.text!=null
                            && input_content.text!=null && input_content.text!=''
                            && input_wr_1.text!='' && input_wr_1.text!=null
                            && cate_value!='카테고리를 선택해주세요'
                        ) {
                          uploaddata();
                          click_upload = 1;
                        }
                        else{
                          show_Alert("빈칸을 모두 입력해주세요!", 1);
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
