class Genre {
  final String genreId;
  final String genre;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Genre({
    required this.genreId,
    required this.genre,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
    genreId: json["genreId"],
    genre: json["genre"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "genreId": genreId,
    "genre": genre,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "deletedAt": deletedAt,
  };
}