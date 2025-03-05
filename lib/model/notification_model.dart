class NotificationModel {
  String? notificationId;
  String? title;
  String? body;
  String? icon;
  String? userId;
  bool? read;
  String? createdAt;
  String? updatedAt;

  NotificationModel(
      {this.notificationId,
        this.title,
        this.body,
        this.icon,
        this.userId,
        this.read,
        this.createdAt,
        this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    title = json['title'];
    body = json['body'];
    icon = json['icon'];
    userId = json['userId'];
    read = json['read'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationId'] = this.notificationId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['icon'] = this.icon;
    data['userId'] = this.userId;
    data['read'] = this.read;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
