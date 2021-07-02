class StsEntity {
  String region;
  String accessKeyId;
  String accessKeySecret;
  String stsToken;
  String bucket;

  StsEntity(
      {this.region,
        this.accessKeyId,
        this.accessKeySecret,
        this.stsToken,
        this.bucket});

  StsEntity.fromJson(Map<String, dynamic> json) {
    region = json['region'];
    accessKeyId = json['accessKeyId'];
    accessKeySecret = json['accessKeySecret'];
    stsToken = json['stsToken'];
    bucket = json['bucket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['region'] = this.region;
    data['accessKeyId'] = this.accessKeyId;
    data['accessKeySecret'] = this.accessKeySecret;
    data['stsToken'] = this.stsToken;
    data['bucket'] = this.bucket;
    return data;
  }
}