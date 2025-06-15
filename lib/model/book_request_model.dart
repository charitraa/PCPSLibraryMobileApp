class BookRequestModel {
  String? bookRequestId;
  String? userId;
  String? title;
  String? authors;
  String? publisher;
  int? publicationYear;
  String? editionStatement;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  User? user;

  BookRequestModel(
      {this.bookRequestId,
        this.userId,
        this.title,
        this.authors,
        this.publisher,
        this.publicationYear,
        this.editionStatement,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.user});

  BookRequestModel.fromJson(Map<String, dynamic> json) {
    bookRequestId = json['bookRequestId'];
    userId = json['userId'];
    title = json['title'];
    authors = json['authors'];
    publisher = json['publisher'];
    publicationYear = json['publicationYear'];
    editionStatement = json['editionStatement'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookRequestId'] = this.bookRequestId;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['authors'] = this.authors;
    data['publisher'] = this.publisher;
    data['publicationYear'] = this.publicationYear;
    data['editionStatement'] = this.editionStatement;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? fullName;
  String? profilePicUrl;
  String? userId;
  String? cardId;

  User({this.fullName, this.profilePicUrl, this.userId, this.cardId});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    profilePicUrl = json['profilePicUrl'];
    userId = json['userId'];
    cardId = json['cardId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['profilePicUrl'] = this.profilePicUrl;
    data['userId'] = this.userId;
    data['cardId'] = this.cardId;
    return data;
  }
}
