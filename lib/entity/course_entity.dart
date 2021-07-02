class CourseEntity {
  int id;
  int videoId;
  String startAt;
  String createAt;
  String updateAt;
  String title;
  String remark;
  int teacherId;
  int sort;
  String avator;
  String description;
  int type;
  int lock;
  int del;
  int category;

  CourseEntity(
      {this.id,
        this.videoId,
        this.startAt,
        this.createAt,
        this.updateAt,
        this.title,
        this.remark,
        this.teacherId,
        this.sort,
        this.avator,
        this.description,
        this.type,
        this.lock,
        this.del,
        this.category
      });

  CourseEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoId = json['video_id'];
    startAt = json['start_at'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    title = json['title'];
    remark = json['remark'];
    teacherId = json['teacherId'];
    sort = json['sort'];
    avator = json['avator'];
    description = json['description'];
    type = json['type'];
    lock = json['lock'];
    del = json['del'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video_id'] = this.videoId;
    data['start_at'] = this.startAt;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    data['title'] = this.title;
    data['teacherId'] = this.teacherId;
    data['sort'] = this.sort;
    data['avator'] = this.avator;
    data['description'] = this.description;
    data['type'] = this.type;
    data['lock'] = this.lock;
    data['del'] = this.del;
    return data;
  }
}
