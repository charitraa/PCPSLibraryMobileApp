class CommentModel {
  String? commentId;
  String? comment;
  String? userId;
  String? bookInfoId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt; // Changed from Null to String?
  User? user;
  List<CommentModel>? replies; // Changed from Null to CommentModel

  CommentModel(
      {this.commentId,
        this.comment,
        this.userId,
        this.bookInfoId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.user,
        this.replies});

  CommentModel.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    comment = json['comment'];
    userId = json['userId'];
    bookInfoId = json['bookInfoId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['replies'] != null) {
      replies = <CommentModel>[]; // Changed from Null to CommentModel
      json['replies'].forEach((v) {
        replies!.add(new CommentModel.fromJson(v)); // Changed from Null to CommentModel
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['comment'] = this.comment;
    data['userId'] = this.userId;
    data['bookInfoId'] = this.bookInfoId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? fullName;
  String? userId;
  String? profilePicUrl;
  List<Ratings>? ratings;

  User({this.fullName, this.userId, this.profilePicUrl, this.ratings});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    userId = json['userId'];
    profilePicUrl = json['profilePicUrl'];
    if (json['ratings'] != null) {
      ratings = <Ratings>[];
      json['ratings'].forEach((v) {
        ratings!.add(new Ratings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['userId'] = this.userId;
    data['profilePicUrl'] = this.profilePicUrl;
    if (this.ratings != null) {
      data['ratings'] = this.ratings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ratings {
  String? bookInfoId;
  String? userId;
  int? rating;
  String? createdAt;
  String? updatedAt;
  String? deletedAt; // Changed from Null to String?

  Ratings(
      {this.bookInfoId,
        this.userId,
        this.rating,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Ratings.fromJson(Map<String, dynamic> json) {
    bookInfoId = json['bookInfoId'];
    userId = json['userId'];
    rating = json['rating'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookInfoId'] = this.bookInfoId;
    data['userId'] = this.userId;
    data['rating'] = this.rating;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
