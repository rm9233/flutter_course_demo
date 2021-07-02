class ProductEntity {
  int id;
  double money;
  double showMoney;
  int total;
  int type;
  String title;
  String avator;
  String description;
  String url;
  String createAt;
  String updateAt;
  String lockAt;
  int lock;
  int del;
  String context;

  ProductEntity(
      {this.id,
        this.money,
        this.showMoney,
        this.total,
        this.type,
        this.title,
        this.avator,
        this.description,
        this.url,
        this.createAt,
        this.updateAt,
        this.lockAt,
        this.lock,
        this.del,
        this.context});

  ProductEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    money = double.parse(json['money'].toString());
    showMoney = double.parse(json['show_money'].toString());
    total = json['total'];
    type = json['type'];
    title = json['title'];
    avator = json['avator'];
    description = json['description'];
    url = json['url'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    lockAt = json['lock_at'];
    lock = json['lock'];
    del = json['del'];
    context = json['context'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['money'] = this.money;
    data['show_money'] = this.showMoney;
    data['total'] = this.total;
    data['type'] = this.type;
    data['title'] = this.title;
    data['avator'] = this.avator;
    data['description'] = this.description;
    data['url'] = this.url;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    data['lock_at'] = this.lockAt;
    data['lock'] = this.lock;
    data['del'] = this.del;
    data['context'] = this.context;
    return data;
  }
}
