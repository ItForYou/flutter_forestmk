import 'dart:convert';

class basic_item{

  final String wr_id;
  final String wr_subject;
  final String wr_hit;
  final String mb_name;
  final String wr_datetime;
  final String mb_id;
  final String wr_content;
  final String comments;

  basic_item({
    this.wr_id,
    this.mb_id,
    this.wr_subject,
    this.mb_name,
    this.wr_datetime,
    this.wr_hit,
    this.comments,
    this.wr_content
  });
  // main_item({this.wr_id,this.wr_content});

  factory basic_item.fromJson(Map<String, dynamic> json){
    return basic_item(
      wr_id: json['wr_id'],
      wr_datetime: json['wr_datetime'],
      wr_subject: json['wr_subject'],
      wr_content: json['wr_content'],
      mb_name: json['mb_name'],
      wr_hit: json['wr_hit'],
      mb_id:  json['mb_id'],
      comments: json['comments']
    );
  }

}



