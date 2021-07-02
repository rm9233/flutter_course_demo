class UnitEntity {
  int id;
  int videoId;
  int sort;
  String title;
  String avator;
  int type;
  String url;
  String scriptUrl;
  String createAt;
  String updateAt;
  int del;

  UnitEntity(
      {this.id,
        this.videoId,
        this.sort,
        this.title,
        this.avator,
        this.type,
        this.url,
        this.scriptUrl,
        this.createAt,
        this.updateAt,
        this.del});

  UnitEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoId = json['videoId'];
    sort = json['sort'];
    title = json['title'];
    avator = json['avator'];
    type = json['type'];
    url = json['url'];
    scriptUrl = json['scriptUrl'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    del = json['del'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['videoId'] = this.videoId;
    data['sort'] = this.sort;
    data['title'] = this.title;
    data['avator'] = this.avator;
    data['type'] = this.type;
    data['url'] = this.url;
    data['scriptUrl'] = this.scriptUrl;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    data['del'] = this.del;
    return data;
  }
}