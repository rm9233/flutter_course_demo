class UnitEntity {
  int id;
  int sort;
  String title;
  String avator;
  int type;
  String url;
  String scriptUrl;
  int videoId;
  int del;

  UnitEntity(
      {this.id,
        this.sort,
        this.title,
        this.avator,
        this.type,
        this.url,
        this.scriptUrl,
        this.videoId,
        this.del});

  UnitEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sort = json['sort'];
    title = json['title'];
    avator = json['avator'];
    type = json['type'];
    url = json['url'];
    scriptUrl = json['scriptUrl'];
    videoId = json['videoId'];
    del = json['del'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sort'] = this.sort;
    data['title'] = this.title;
    data['avator'] = this.avator;
    data['type'] = this.type;
    data['url'] = this.url;
    data['scriptUrl'] = this.scriptUrl;
    data['videoId'] = this.videoId;
    data['del'] = this.del;
    return data;
  }
}