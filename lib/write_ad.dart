import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kopo/kopo.dart';

class write_ad extends StatefulWidget {
  @override
  writead_State createState() => writead_State();
}

class writead_State extends State<write_ad> {

  Color color_cate = Color(0xff888888);
  List<Widget> image_boxes = List<Widget>();
  List<File> Images = [];
  int first_build =1;
  double grid_height;
  String str_address ="주소를 입력해주세요";

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
                                grid_height = MediaQuery.of(context).size.height*0.25;
                              }
                              else if(Images.length >7){
                              grid_height = MediaQuery.of(context).size.height*0.35;
                              }
                              else{
                                grid_height = MediaQuery.of(context).size.height*0.14;
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
                  .width * 0.065,
              child: Text(
                "("+(Images.length+1).toString()+"/10)",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width*0.03),
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
          grid_height = MediaQuery.of(context).size.height*0.25;
        }
        else if(Images.length >7){
          grid_height = MediaQuery.of(context).size.height*0.35;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(first_build ==1 && image_boxes.length <=0){
      grid_height = MediaQuery.of(context).size.height*0.14;
      image_boxes.add(get_addbox());
    }
    /*if(image_boxes.length < 10) {
      image_boxes.add(get_addbox());
    }*/

    return Scaffold(

      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("광고문의 글쓰기" ,style: TextStyle(color: Colors.black),),
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
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.8,
            child: ListView(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.08,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Text("홍보 사진 첨부", style: TextStyle(fontWeight:FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.04,),),
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.05,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("주소",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,)),
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
                                    child:Text(str_address,style: TextStyle(color: color_cate,fontSize: MediaQuery.of(context).size.width*0.04,),textAlign: TextAlign.start,)
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
                             str_address = '${model.sido}  ${model.sigungu} ${model.bname}';
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
                      Text("전화번호",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,)),
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
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "전화번호를 입력하세요"
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
                      Text("업체이름",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,)),
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
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "업체이름을 입력하세요"
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
                      Text("내용",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,)),
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
                    top: MediaQuery.of(context).size.width*0.05,bottom: MediaQuery.of(context).size.width*0.05,),
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01),
                  child: TextField(
                    maxLines: null,
                    cursorColor: Color(0xff9dc543),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "내용을 입력해주세요",
                        hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.075,
              color: Colors.grey,
              child: Center(child: Text("등록하기",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.055, color: Colors.white,)),
              )
          )
        ],
      ),
    );
  }
}
