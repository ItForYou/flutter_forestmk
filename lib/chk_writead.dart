
import 'package:flutter/material.dart';
import 'package:flutterforestmk/write_ad.dart';
import 'package:flutterforestmk/write_normal.dart';

class chk_writead extends StatefulWidget {
  @override
  _chk_writeadState createState() => _chk_writeadState();
}

class _chk_writeadState extends State<chk_writead> {

  int flg_value = 0;

  Widget get_textbox(msg){
    Widget temp = Text(
      msg,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize:MediaQuery.of(context).size.width*0.032,

      ),
    );
    return temp;
  }

  Widget get_number(num){
    Widget temp = Container(
        width: MediaQuery.of(context).size.width*0.05,
        height: MediaQuery.of(context).size.width*0.05,
        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.01,bottom: MediaQuery.of(context).size.height*0.003),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.06)),
            color: Color(0xff00b5af)
        ),
        child: Center(child: Text(num, style: TextStyle(color: Color(0xffffffff)),))
    );
    return temp;
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:null,
          content: Container(
            height: MediaQuery.of(context).size.height*0.02,
            child: Text("동의시 글작성이 가능합니다."),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("광고문의 이용약관" ,style: TextStyle(color: Colors.black),),
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
      body: Column(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.72,
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width*0.03,
                right: MediaQuery.of(context).size.width*0.03,
                top: MediaQuery.of(context).size.height*0.01,
                ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2, color: Color(0xfff7f7f7))
              ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width*0.03,
                    right: MediaQuery.of(context).size.width*0.03,
                    top: MediaQuery.of(context).size.height*0.025,
                    bottom: MediaQuery.of(context).size.height*0.025,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    get_textbox("안녕하십니까? 숲마켓입니다.\n저희 광고문의를 이용해주셔서 대단히 감사드립니다.\n저희는 광고를 게재해드리기전 이용약관의 동의를 받고있습니다."),
                    SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                    Text(
                      "숲마켓 광고문의 서비스",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize:MediaQuery.of(context).size.width*0.04,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Row(
                      children: <Widget>[
                       get_number("1"),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child:
                          get_textbox("저희 숲마켓 에서는 회원수 대비의 광고료를 받고 게재를 해드"),
                        ),

                      ],
                    ),
                    get_textbox("리고 있습니다."),
                    Row(
                      children: <Widget>[
                        get_number("2"),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child:
                          get_textbox("불건전한 광고는 확인검수후 게시 불가합니다. (아래 항목참조)"),
                        ),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        get_number("3"),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child:
                          get_textbox("광고게재는 게시글 등록된후 다음날로부터 체크하신 7일, 14일,"),
                        ),

                      ],
                    ),
                    get_textbox("21일, 28일 게재하고 있습니다.  (계약날이 지나면 게시물은 자동삭제 됩니다)"),
                    Row(
                      children: <Widget>[
                        get_number("4"),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child:
                          get_textbox("게시글 등록후로부터 숲마켓 관리자가 직접 검수후 24시간이내"),
                        ),

                      ],
                    ),
                    get_textbox("로 업체 표기번호로 유선상으로 협의후 게재합니다."),
                    Row(
                      children: <Widget>[
                        get_number("5"),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child:
                          get_textbox("게시글 업로드후 수정 및 연장은 불가합니다."),
                        ),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        get_number("6"),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child:
                          get_textbox("부가가치세는 별도입니다."),
                        ),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        get_number("7"),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child:
                          get_textbox("광고 게시물을 최신 글 업데이트 방법은 나의 메뉴의 '나의 광"),
                        ),

                      ],
                    ),
                    get_textbox("고'에서 맨 위로 올릴 수 있으며, 기간내에만 사용하실 수 있습니다."),
                    SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                    Text(
                      "광고 게재제한",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize:MediaQuery.of(context).size.width*0.04,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Row(
                      children: <Widget>[
                        get_number("1"),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child:
                          get_textbox("광고 미승인 및 게재제한 사유 : 회사에 법률적 또는 재산적 위험"),
                        ),

                      ],
                    ),
                    get_textbox("을 발생시키거나 발생시킬 우려가 있는 경우"),

                    Row(
                      children: <Widget>[
                        get_number("2"),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child:
                          get_textbox("광고가 관련 법령을 위반하는 상점, 상품 또는 서비스를 홍보함"),
                        ),

                      ],
                    ),
                    get_textbox("으로써 회사가 민.형사적 책임을 부담할 가능성이 있는경우"),
                    Row(
                      children: <Widget>[
                        get_number("3"),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: get_textbox("광고가 관련 법령을 위반하는 회원의 영업행위 들에 연계됨으"),
                        ),

                      ],
                    ),
                    get_textbox("로써 회사가 민.형사적 책임을 부담할 가능성이 있는 경우"),
                    SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                    Text(
                      "ex대표적인 사례들",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize:MediaQuery.of(context).size.width*0.04,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    get_textbox("- 출장 안마/마사지,단란주점,유흥업소 등 성매매 연계 개연성이 있는사례"),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    get_textbox("- 흥신소/심부름센터 업소 내에서 개인사생활 조사 등의 서비스를 제공하는 사례"),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    get_textbox("- 검증된 의료기관이 아닌 문신/반영구 시술 서비스를 제공하는 사례"),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    get_textbox("- 타업체의 명예 평판 신용 을 훼손하거나 훼손할 우려가 있는 경우"),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    get_textbox("- 대출 또는 사채서비스를 제공하는 사례"),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    get_textbox("- 애인대행 서비스 제공하는 사례"),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    get_textbox("- 다단계 업체의 구인광고를 하는 사례"),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    get_textbox("- 해피벌론, 전자담배, 본드(마약류) 를 판매하는 사례"),
                    SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                    Text(
                      "광고료의 대한 안내",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize:MediaQuery.of(context).size.width*0.04,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    get_textbox("광고료는 유선상 실시간으로 안드로이드, 아이폰 다운로드수를 공지시켜드리며, 숲마켓 회원수당 7일기준/1원으로 광고료가 책정되며 유선상 안내를 드립니다."),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.94,
                      height: MediaQuery.of(context).size.height*0.085,
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.02,
                          right: MediaQuery.of(context).size.width*0.02,
                          top: MediaQuery.of(context).size.height*0.01,
                          bottom: MediaQuery.of(context).size.height*0.01,
                      ),
                      color: Color(0xffcccccc),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("안드로이드의 다운로드수 1,000명",style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.017),),
                          Text("아이폰의 다운로드수 1,000명",style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.017)),
                          Text(" 합 2,000 명",style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.017)),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.94,
                      height: MediaQuery.of(context).size.height*0.2,
                      child: Table(
                        border: TableBorder.all(color: Color(0xffdddddd), width: 2),
                        children: [
                          TableRow(
                              children:[
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Center(
                                      child: Text(
                                        "다운로드×1"
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                      color: Color(0xfffbfbfb)
                                    ),
                                    child: Center(
                                      child: Text(
                                          "7일 기준"
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Center(
                                      child: Text(
                                          "2,000원"
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          TableRow(
                              children:[
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Center(
                                      child: Text(
                                          "다운로드×2"
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Color(0xfffbfbfb)
                                    ),
                                    child: Center(
                                      child: Text(
                                          "14일 기준"
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Center(
                                      child: Text(
                                          "4,000원"
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          TableRow(
                              children:[
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Center(
                                      child: Text(
                                          "다운로드×3"
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Color(0xfffbfbfb)
                                    ),
                                    child: Center(
                                      child: Text(
                                          "21일 기준"
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Center(
                                      child: Text(
                                          "6,000원"
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          TableRow(
                              children:[
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Center(
                                      child: Text(
                                          "다운로드×4"
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Color(0xfffbfbfb)
                                    ),
                                    child: Center(
                                      child: Text(
                                          "28일 기준"
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Center(
                                      child: Text(
                                          "8,000원"
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.06,
            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.04),
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[


                       Radio(
                        value: 1,
                        groupValue: flg_value,
                        activeColor: Color(0xff00b5af),
                        onChanged: (T){
                          setState(() {
                            flg_value =T;
                          });
                        },
                    ),
                  InkWell(
                      child: Text("동의"),
                      onTap: (){
                        setState(() {
                          flg_value =1;
                        });
                    },
                  ),
                 Radio(
                    value: 0,
                    groupValue: flg_value,
                    activeColor: Color(0xff00b5af),
                    onChanged: (T){
                      setState(() {
                        flg_value =T;
                      });
                    },
                  ),
                  InkWell(
                      onTap: (){
                        setState(() {
                          flg_value =0;
                        });
                      },
                      child: Text("미동의")),
                ],
            ),
          ),
          SafeArea(
            child: InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.085,
                color: Colors.grey,
                child: Center(
                    child:
                        Text("확인" ,
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05, color: Colors.white),),
                    )
              ),
              onTap: (){
                if(flg_value==1) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => write_ad()
                  ));
                }
                else{
                  _showDialog();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
