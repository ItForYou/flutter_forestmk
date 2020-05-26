class member_info{

  final String mb_id, mb_1, mb_2, mb_name, mb_hp;

  member_info({
    this.mb_name,
    this.mb_2,
    this.mb_1,
    this.mb_hp,
    this.mb_id
});
  // main_item({this.wr_id,this.wr_content});

  factory member_info.fromJson(Map<String, dynamic> json){
    return member_info(
      mb_id: json['mb_id'],
      mb_1: json['mb_1'],
      mb_2: json['mb_2'],
      mb_name: json['mb_name'],
      mb_hp: json['mb_hp'],
    );
  }


}


