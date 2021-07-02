class OrderEntity {
  int id;
  int productId;
  int userId;
  String createAt;
  int payStatus;
  String title;
  String order_number;
  String avator;
  int lock;
  int del;
  String lockAt;
  String payAt;
  double money;
  List<Courses> courses;

  OrderEntity(
      {this.id,
        this.productId,
        this.userId,
        this.createAt,
        this.payStatus,
        this.title,
        this.order_number,
        this.avator,
        this.lock,
        this.del,
        this.lockAt,
        this.payAt,
        this.money,
        this.courses});

  OrderEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    userId = json['user_id'];
    createAt = json['create_at'];
    payStatus = json['pay_status'];
    title = json['title'];
    order_number = json['order_number'];
    avator = json['avator'];
    lock = json['lock'];
    del = json['del'];
    lockAt = json['lock_at'];
    payAt = json['pay_at'];
    money = json['money'];
    if (json['courses'] != null) {
      courses = new List<Courses>();
      json['courses'].forEach((v) {
        courses.add(new Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['user_id'] = this.userId;
    data['create_at'] = this.createAt;
    data['pay_status'] = this.payStatus;
    data['title'] = this.title;
    data['avator'] = this.avator;
    data['lock'] = this.lock;
    data['del'] = this.del;
    data['lock_at'] = this.lockAt;
    data['money'] = this.money;
    if (this.courses != null) {
      data['courses'] = this.courses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Courses {
  int id;
  String title;
  Null avator;
  String createAt;
  String updateAt;
  int lock;
  int del;
  int productId;

  Courses(
      {this.id,
        this.title,
        this.avator,
        this.createAt,
        this.updateAt,
        this.lock,
        this.del,
        this.productId});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    avator = json['avator'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    lock = json['lock'];
    del = json['del'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['avator'] = this.avator;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    data['lock'] = this.lock;
    data['del'] = this.del;
    data['productId'] = this.productId;
    return data;
  }
}