class SplashEntity {
  String images;
  String url;
  String title;

  SplashEntity({this.images, this.url});

  SplashEntity.fromJson(Map<String, dynamic> json) {
    images = json['images'];
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['url'] = this.url;
    data['title'] = this.title;
    return data;
  }
}