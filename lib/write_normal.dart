import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


class write_normal extends StatefulWidget {
  @override
  writenormal_State createState() => writenormal_State();
}

class writenormal_State extends State<write_normal> {
  String cate_value ="카테고리를 선택해주세요";
  Color color_cate = Color(0xff888888);
  List<Widget> image_boxes = List<Widget>();
  List<File> Images = [];
  int first_build =1;
  double grid_height;


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

  List<Widget> get_allcateitem(){
    List<Widget> items = List<Widget>();
    var menu_names = ["생활용품", "여성의류", "가구/인테리어", "여성잡화", "디지털/가전","남성의류", "자동차/오토바이","남성잡화",
      "게임/취미","유아용품","스포츠/레저","뷰티/미용","도서","반려동물용품","식품","건강/의료용품","기타물품","부동산",];
    var cnt;
    for(int i=0; i<menu_names.length; i++){
      if(i+1 < 10){
        cnt  = "0"+(i+1).toString();
      }
      else{
        cnt  = (i+1).toString();
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
                          Image.network("http://14.48.175.177/theme/basic_app/img/app/category"+cnt.toString()+".png"),
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
              children: get_allcateitem(),
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("중고거래 글쓰기" ,style: TextStyle(color: Colors.black),),
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
                      Text("제품 사진 첨부", style: TextStyle(fontWeight:FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.04,),),
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
                      Text("카테고리",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,)),
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
                      Text("금액",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,)),
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
                      Text("제목",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,)),
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
