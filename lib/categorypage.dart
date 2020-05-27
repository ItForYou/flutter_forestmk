
import 'package:flutter/material.dart';
import 'package:flutterforestmk/main.dart';
import 'package:flutterforestmk/search_main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class categorypage  extends StatefulWidget {
  @override
  _categorypageState createState() => _categorypageState();
}

class _categorypageState extends State<categorypage> {

  var menu_names = ["전체보기", "생활용품", "여성의류", "가구/인테리어", "여성잡화", "디지털/가전","남성의류", "자동차/오토바이","남성잡화",
                    "게임/취미","유아용품","스포츠/레저","뷰티/미용","도서","반려동물용품","식품","건강/의료용품","기타물품","부동산",];

  String mb_id,mb_pwd,mb_name,mb_hp,mb_1='test',mb_2,mb_3,mb_4,mb_5,mb_6;

  Widget getitems(id){
    String path_img=""+id.toString();
    if(id <10){
      path_img  = "0"+id.toString();
    }
    else{
      path_img  = id.toString();
    }
    Widget temp = InkWell(
        child:Container(
        decoration : id%2 ==0? BoxDecoration(border: Border(right: BorderSide( color: Color(0xffdddddd),width: 1))):null,
        width: MediaQuery.of(context).size.width*0.5,
        height: MediaQuery.of(context).size.height*0.08,
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.055, top: 10,bottom: 10,),
        child:Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/category"+path_img+".png"),
              Text(menu_names[id])
            ],
          ),
        ),
      onTap: (){
          if(id ==0)
            Navigator.push(context,MaterialPageRoute(
                builder:(context) => MyApp()
            ));
          else {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => search_main(sch_cate: menu_names[id] , mb_id:mb_id,mb_1: mb_1,mb_2: mb_2,mb_3: mb_3, mb_4: mb_4, mb_hp: mb_hp, mb_5: mb_5, mb_6: mb_6,mb_name: mb_name,)
            ));
          }
      },
    );

    return temp;
  }

  void load_myinfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      if(sp.getString('id')!=null) {
        mb_id = sp.getString('id');
        mb_pwd = sp.getString('pwd');
        mb_name = sp.getString('mb_name');
        mb_hp = sp.getString('mb_hp');
        mb_1 = sp.getString('mb_1');
        mb_2 = sp.getString('mb_2');
        mb_3 = sp.getString('mb_3');
        mb_4 = sp.getString('mb_4');
        mb_5 = sp.getString('mb_5');
        mb_6 = sp.getString('mb_6');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_myinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("홈으로" ,style: TextStyle(color: Colors.black),),
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
      body: Column(
        children: <Widget>[
            Container(
              width:  MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.01, bottom: MediaQuery.of(context).size.height*0.01, left: MediaQuery.of(context).size.width*0.06,),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xffdddddd))),color: Colors.white),
              child: Text("카테고리", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.025, ),),
            ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.825,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    getitems(0),
                    getitems(2),
                    getitems(4),
                    getitems(6),
                    getitems(8),
                    getitems(10),
                    getitems(12),
                    getitems(14),
                    getitems(16),
                    getitems(18),

                  ],
                ),
                Column(
                  children: <Widget>[
                    getitems(1),
                    getitems(3),
                    getitems(5),
                    getitems(7),
                    getitems(9),
                    getitems(11),
                    getitems(13),
                    getitems(15),
                    getitems(17),
                  ],
                )

              ],
            ),

          )
        ],
      ),

    );
  }
}
