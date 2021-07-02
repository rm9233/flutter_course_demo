class ScriptEntity {
  int videoId;
  int unitId;
  int show;
  int hide;
  String url;
  int type;
  int del;

  ScriptEntity(
      {this.videoId,
      this.unitId,
      this.show,
      this.hide,
      this.url,
      this.type,
      this.del});

  ScriptEntity.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
    unitId = json['unitId'];
    show = json['show'];
    hide = json['hide'];
    url = json['url'];
    type = json['type'];
    del = json['del'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['videoId'] = this.videoId;
    data['unitId'] = this.unitId;
    data['show'] = this.show;
    data['hide'] = this.hide;
    data['url'] = this.url;
    data['type'] = this.type;
    data['del'] = this.del;
    return data;
  }
}
