class view_item{

  final String wr_1;
  final String wr_id;
  final String file;
  final String wr_subject;

  view_item({
    this.wr_1,
    this.wr_id,
    this.wr_subject,
    this.file,
  });

  factory view_item.fromJson(Map<String, dynamic> json){
    return view_item(
      wr_id: json['wr_id'],
      wr_subject: json['wr_subject'],
      wr_1: json['wr_1'],
      file: json['file'],
    );
  }
}



