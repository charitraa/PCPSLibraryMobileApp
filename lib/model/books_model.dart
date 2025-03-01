class BooksModel {
  String? bookInfoId;
  String? classNumber;
  String? bookNumber;
  String? title;
  String? subTitle;
  String? editionStatement;
  int? numberOfPages;
  int? publicationYear;
  String? seriesStatement;
  String? addedDate;
  String? coverPhoto;
  String? createdAt;
  String? updatedAt;
  DateTime? deletedAt;
  String? publisherId;
  Publisher? publisher;
  List<BookGenres>? bookGenres;
  List<BookAuthors>? bookAuthors;

  BooksModel({
    this.bookInfoId,
    this.classNumber,
    this.bookNumber,
    this.title,
    this.subTitle,
    this.editionStatement,
    this.numberOfPages,
    this.publicationYear,
    this.seriesStatement,
    this.addedDate,
    this.coverPhoto,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.publisherId,
    this.publisher,
    this.bookGenres,
    this.bookAuthors,
  });

  BooksModel.fromJson(Map<String, dynamic> json) {
    bookInfoId = json['bookInfoId'];
    classNumber = json['classNumber'];
    bookNumber = json['bookNumber'];
    title = json['title'];
    subTitle = json['subTitle'];
    editionStatement = json['editionStatement'];
    numberOfPages = json['numberOfPages'];
    publicationYear = json['publicationYear'];
    seriesStatement = json['seriesStatement'];
    addedDate = json['addedDate'];
    coverPhoto = json['coverPhoto'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null;
    publisherId = json['publisherId'];
    publisher = json['publisher'] != null ? Publisher.fromJson(json['publisher']) : null;

    if (json['bookGenres'] != null) {
      bookGenres = List<BookGenres>.from(json['bookGenres'].map((v) => BookGenres.fromJson(v)));
    }
    if (json['bookAuthors'] != null) {
      bookAuthors = List<BookAuthors>.from(json['bookAuthors'].map((v) => BookAuthors.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bookInfoId'] = bookInfoId;
    data['classNumber'] = classNumber;
    data['bookNumber'] = bookNumber;
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['editionStatement'] = editionStatement;
    data['numberOfPages'] = numberOfPages;
    data['publicationYear'] = publicationYear;
    data['seriesStatement'] = seriesStatement;
    data['addedDate'] = addedDate;
    data['coverPhoto'] = coverPhoto;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt?.toIso8601String();
    data['publisherId'] = publisherId;
    if (publisher != null) {
      data['publisher'] = publisher!.toJson();
    }
    if (bookGenres != null) {
      data['bookGenres'] = bookGenres!.map((v) => v.toJson()).toList();
    }
    if (bookAuthors != null) {
      data['bookAuthors'] = bookAuthors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Publisher {
  String? publisherId;
  String? publisherName;
  String? address;
  String? createdAt;
  String? updatedAt;
  DateTime? deletedAt;

  Publisher({
    this.publisherId,
    this.publisherName,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Publisher.fromJson(Map<String, dynamic> json) {
    publisherId = json['publisherId'];
    publisherName = json['publisherName'];
    address = json['address'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['publisherId'] = publisherId;
    data['publisherName'] = publisherName;
    data['address'] = address;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt?.toIso8601String();
    return data;
  }
}

class BookGenres {
  String? bookGenreId;
  String? bookInfoId;
  String? genreId;
  String? createdAt;
  String? updatedAt;
  DateTime? deletedAt;

  BookGenres({
    this.bookGenreId,
    this.bookInfoId,
    this.genreId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  BookGenres.fromJson(Map<String, dynamic> json) {
    bookGenreId = json['bookGenreId'];
    bookInfoId = json['bookInfoId'];
    genreId = json['genreId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bookGenreId'] = bookGenreId;
    data['bookInfoId'] = bookInfoId;
    data['genreId'] = genreId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt?.toIso8601String();
    return data;
  }
}

class BookAuthors {
  String? bookAuthorId;
  String? bookInfoId;
  String? authorId;
  String? createdAt;
  String? updatedAt;
  DateTime? deletedAt;

  BookAuthors({
    this.bookAuthorId,
    this.bookInfoId,
    this.authorId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  BookAuthors.fromJson(Map<String, dynamic> json) {
    bookAuthorId = json['bookAuthorId'];
    bookInfoId = json['bookInfoId'];
    authorId = json['authorId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bookAuthorId'] = bookAuthorId;
    data['bookInfoId'] = bookInfoId;
    data['authorId'] = authorId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt?.toIso8601String();
    return data;
  }
}
