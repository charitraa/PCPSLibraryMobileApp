class Author {
  final String authorId;
  final String title;
  final String fullName;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Author({
    required this.authorId,
    required this.title,
    required this.fullName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    authorId: json["authorId"],
    title: json["title"],
    fullName: json["fullName"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "authorId": authorId,
    "title": title,
    "fullName": fullName,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "deletedAt": deletedAt,
  };
}