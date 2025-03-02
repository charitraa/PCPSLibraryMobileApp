class CommentModel {
  String? commentId;
  String? comment;
  String? userId;
  String? bookInfoId;

  CommentModel({this.commentId, this.comment, this.userId, this.bookInfoId});

  CommentModel.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    comment = json['comment'];
    userId = json['userId'];
    bookInfoId = json['bookInfoId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['comment'] = this.comment;
    data['userId'] = this.userId;
    data['bookInfoId'] = this.bookInfoId;
    return data;
  }
}
