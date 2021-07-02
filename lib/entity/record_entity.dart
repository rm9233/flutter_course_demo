class RecordEntity {
  int userId;
  int videoId;
  int unitId;
  int del;
  double progress;

  RecordEntity({this.userId, this.videoId, this.unitId, this.del, this.progress});

  RecordEntity.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    videoId = json['video_id'];
    unitId = json['unit_id'];
    del = json['del'];
    progress = double.parse(json['progress'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['video_id'] = this.videoId;
    data['unit_id'] = this.unitId;
    data['del'] = this.del;
    data['progress'] = this.progress;
    return data;
  }
}