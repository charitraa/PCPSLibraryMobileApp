class OnlineBooks {
  String? onlineBookId;
  String? purchaseUrl;
  String? resourceUrl;
  String? fileUrl;
  String? title;
  String? coverPhoto;
  String? bookInfoId;
  String? type;
  String? createdAt;
  String? updatedAt;

  OnlineBooks(
      {this.onlineBookId,
        this.purchaseUrl,
        this.resourceUrl,
        this.fileUrl,
        this.title,
        this.coverPhoto,
        this.bookInfoId,
        this.type,
        this.createdAt,
        this.updatedAt});

  OnlineBooks.fromJson(Map<String, dynamic> json) {
    onlineBookId = json['onlineBookId'];
    purchaseUrl = json['purchaseUrl'];
    resourceUrl = json['resourceUrl'];
    fileUrl = json['fileUrl'];
    title = json['title'];
    coverPhoto = json['coverPhoto'];
    bookInfoId = json['bookInfoId'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['onlineBookId'] = this.onlineBookId;
    data['purchaseUrl'] = this.purchaseUrl;
    data['resourceUrl'] = this.resourceUrl;
    data['fileUrl'] = this.fileUrl;
    data['title'] = this.title;
    data['coverPhoto'] = this.coverPhoto;
    data['bookInfoId'] = this.bookInfoId;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
