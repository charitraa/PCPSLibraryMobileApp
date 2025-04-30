class CommentModel {
  final String? commentId;
  final String? comment;
  final String? userId;
  final String? bookInfoId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final User? user;
  final List<RepliesModel>? replies;

  CommentModel({
    this.commentId,
    this.comment,
    this.userId,
    this.bookInfoId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    commentId: json['commentId'],
    comment: json['comment'],
    userId: json['userId'],
    bookInfoId: json['bookInfoId'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    deletedAt: json['deletedAt'],
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    replies: json['replies'] != null
        ? (json['replies'] as List)
        .map((v) => RepliesModel.fromJson(v))
        .toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    'commentId': commentId,
    'comment': comment,
    'userId': userId,
    'bookInfoId': bookInfoId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'deletedAt': deletedAt,
    'user': user?.toJson(),
    'replies': replies?.map((v) => v.toJson()).toList(),
  };
}

class RepliesModel {
  final String? commentReplyId;
  final String? reply;
  final String? userId;
  final String? commentId;
  final String? createdAt;
  final String? updatedAt;
  final User? user;

  RepliesModel({
    this.commentReplyId,
    this.reply,
    this.userId,
    this.commentId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory RepliesModel.fromJson(Map<String, dynamic> json) => RepliesModel(
    commentReplyId: json['commentReplyId'],
    reply: json['reply'],
    userId: json['userId'],
    commentId: json['commentId'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    user: json['user'] != null ? User.fromJson(json['user']) : null,
  );

  Map<String, dynamic> toJson() => {
    'commentReplyId': commentReplyId,
    'reply': reply,
    'userId': userId,
    'commentId': commentId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'user': user?.toJson(),
  };
}

class User {
  final String? fullName;
  final String? userId;
  final String? profilePicUrl;
  final List<Ratings>? ratings;

  User({
    this.fullName,
    this.userId,
    this.profilePicUrl,
    this.ratings,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json['fullName'],
    userId: json['userId'],
    profilePicUrl: json['profilePicUrl'],
    ratings: json['ratings'] != null
        ? (json['ratings'] as List)
        .map((v) => Ratings.fromJson(v))
        .toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'userId': userId,
    'profilePicUrl': profilePicUrl,
    'ratings': ratings?.map((v) => v.toJson()).toList(),
  };
}

class Ratings {
  final String? bookInfoId;
  final String? userId;
  final int? rating;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Ratings({
    this.bookInfoId,
    this.userId,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) => Ratings(
    bookInfoId: json['bookInfoId'],
    userId: json['userId'],
    rating: json['rating'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    deletedAt: json['deletedAt'],
  );

  Map<String, dynamic> toJson() => {
    'bookInfoId': bookInfoId,
    'userId': userId,
    'rating': rating,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'deletedAt': deletedAt,
  };
}
