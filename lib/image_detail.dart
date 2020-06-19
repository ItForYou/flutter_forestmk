
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterforestmk/main_item.dart';

class image_detail extends StatefulWidget {

  final List<dynamic> info;
  final flg_view;
  image_detail({Key key, this.info, this.flg_view}) : super(key: key);

  @override
  _image_detailState createState() => _image_detailState();
}

class _image_detailState extends State<image_detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("상세보기" ,style: TextStyle(color: Colors.black),),
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
      body: Swiper(
        itemCount: widget.flg_view ==1 ?widget.info.length-1:widget.info.length,
        itemBuilder: (BuildContext context, int index){
          return Image.network(widget.flg_view ==1?widget.info[index+1]:widget.info[index]);
        },
        pagination: (widget.flg_view==1 && (widget.info.length-1)>1)|| (widget.flg_view==2 && (widget.info.length)>1)?SwiperPagination():null,
        loop: (widget.flg_view==1 && (widget.info.length-1)>1)|| (widget.flg_view==2 && (widget.info.length)>1)? true:false,
      ),
    );
  }
}
