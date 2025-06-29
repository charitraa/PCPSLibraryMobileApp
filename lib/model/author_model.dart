class Author {
  String? authorId;
  String? title;
  String? fullName;
  String? createdAt;
  String? updatedAt;

  Author(
      {this.authorId,
        this.title,
        this.fullName,
        this.createdAt,
        this.updatedAt});

  Author.fromJson(Map<String, dynamic> json) {
    authorId = json['authorId'];
    title = json['title'];
    fullName = json['fullName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authorId'] = this.authorId;
    data['title'] = this.title;
    data['fullName'] = this.fullName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
