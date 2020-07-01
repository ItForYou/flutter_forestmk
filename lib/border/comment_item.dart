import 'dart:convert';

class comment_item{

  final String wr_id;
  final String wr_parent;
  final String wr_content;
  final String wr_comment;
  final String ca_name;
  final String wr_datetime;
  final String mb_id;
  final String mb_name;


  comment_item({
    this.wr_id,
    this.mb_id,
    this.mb_name,
    this.ca_name,
    this.wr_content,
    this.wr_datetime,
    this.wr_parent,
    this.wr_comment
  });
  // main_item({this.wr_id,this.wr_content});

  factory comment_item.fromJson(Map<String, dynamic> json){
    return comment_item(
      wr_content: json['wr_content'],
      wr_comment: json['wr_comment'],
      wr_id: json['wr_id'],
      wr_parent: json['wr_parent'],
      wr_datetime: json['wr_datetime'],
      ca_name: json['ca_name'],
      mb_id:  json['mb_id'],
      mb_name:  json['wr_name'],
    );
  }


}



