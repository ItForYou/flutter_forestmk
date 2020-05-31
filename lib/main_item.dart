import 'dart:convert';

class main_item{

    final String wr_id;
    final String wr_content;
   final String wr_subject;
    final String ca_name;
    final String wr_1;
    final String wr_2;
    final String wr_3;
    final String wr_4;
    final String wr_5;
    final String wr_6;
    final String wr_7;
    final String wr_8;
    final String wr_9;
    final String wr_10;
    final String wr_11;
    final String wr_hit;
    final String mb_2;
    final String mb_name;
    final String profile_img;
    final String wr_datetime;
    final List<dynamic> file;
    final String timegap;
    final String like;
    final String mb_id;
    final String comments;


    main_item({
      this.wr_id,
      this.mb_id,
      this.wr_subject,
      this.ca_name,
      this.file,
      this.like,
      this.mb_2,
      this.timegap,
      this.mb_name,
      this.comments,
      this.profile_img,
      this.wr_content,
      this.wr_datetime,
      this.wr_hit,
      this.wr_1,
      this.wr_2,
      this.wr_3,
      this.wr_4,
      this.wr_5,
      this.wr_6,
      this.wr_7,
      this.wr_8,
      this.wr_9,
      this.wr_10,
      this.wr_11,
    });
   // main_item({this.wr_id,this.wr_content});

    factory main_item.fromJson(Map<String, dynamic> json){
      return main_item(
       wr_content: json['wr_content'],
       wr_id: json['wr_id'],
       wr_datetime: json['wr_datetime'],
       wr_subject: json['wr_subject'],
       comments: json['comments'],
       ca_name: json['ca_name'],
       mb_2: json['mb_2'],
       timegap: json['timegap'],
       mb_name: json['mb_name'],
       file: json['files'],
       profile_img: json['mb_1'],
       wr_hit: json['wr_hit'],
       mb_id:  json['mb_id'],
       wr_1: json['wr_1'],
       wr_2: json['wr_2'],
       wr_3: json['wr_3'],
       wr_4: json['wr_4'],
       wr_5: json['wr_5'],
       wr_6: json['wr_6'],
       wr_7: json['wr_7'],
       wr_8: json['wr_8'],
       wr_9: json['wr_9'],
       like: json['wr_10'],
       wr_11: json['wr_11'],
      );
    }


}



