class BannerEntity {
  int type;
  String url;
  String banner;

  BannerEntity({this.type, this.url, this.banner});

  BannerEntity.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    banner = json['banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    data['banner'] = this.banner;
    return data;
  }
}