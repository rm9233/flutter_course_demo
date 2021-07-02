class UserEntity {
  int id;
  String nickName;
  String mobile;
  String password;
  String avator;
  int sex;
  int lock;
  String birthday;
  String createAt;
  String updateAt;
  String remark;
  String platform;
  String deviceInfo;
  int award;
  int groupId;
  String unionid;
  String channel;
  int del;
  String token;

  UserEntity(
      {this.id,
        this.nickName,
        this.mobile,
        this.password,
        this.avator,
        this.sex,
        this.lock,
        this.birthday,
        this.createAt,
        this.updateAt,
        this.remark,
        this.platform,
        this.deviceInfo,
        this.award,
        this.groupId,
        this.unionid,
        this.channel,
        this.del,
        this.token});

  UserEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickName = json['nick_name'];
    mobile = json['mobile'];
    password = json['password'];
    avator = json['avator'];
    sex = json['sex'];
    lock = json['lock'];
    birthday = json['birthday'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    remark = json['remark'];
    platform = json['platform'];
    deviceInfo = json['device_info'];
    award = json['award'];
    groupId = json['group_id'];
    unionid = json['unionid'];
    channel = json['channel'];
    del = json['del'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nick_name'] = this.nickName;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['avator'] = this.avator;
    data['sex'] = this.sex;
    data['lock'] = this.lock;
    data['birthday'] = this.birthday;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    data['remark'] = this.remark;
    data['platform'] = this.platform;
    data['device_info'] = this.deviceInfo;
    data['award'] = this.award;
    data['group_id'] = this.groupId;
    data['unionid'] = this.unionid;
    data['channel'] = this.channel;
    data['del'] = this.del;
    data['token'] = this.token;
    return data;
  }
}
