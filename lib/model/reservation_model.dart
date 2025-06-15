class ReservationModel {
  String? reservationId;
  String? userId;
  String? reservationDate;
  String? status;
  String? bookId;
  String? bookInfoId;
  String? createdAt;
  String? updatedAt;
  BookInfo? bookInfo;
  Book? book;
  User? user;
  List<BookImage>? bookImages;

  ReservationModel({
    this.reservationId,
    this.userId,
    this.reservationDate,
    this.status,
    this.bookId,
    this.bookInfoId,
    this.createdAt,
    this.updatedAt,
    this.bookInfo,
    this.book,
    this.user,
    this.bookImages,
  });

  ReservationModel.fromJson(Map<String, dynamic> json) {
    reservationId = json['reservationId'];
    userId = json['userId'];
    reservationDate = json['reservationDate'];
    status = json['status'];
    bookId = json['bookId'];
    bookInfoId = json['bookInfoId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    bookInfo = json['bookInfo'] != null
        ? BookInfo.fromJson(json['bookInfo'])
        : null;
    book = json['book'] != null ? Book.fromJson(json['book']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;

    // Populate bookImages from bookInfo.bookImages
    if (bookInfo != null && json['bookInfo']['bookImages'] != null) {
      bookImages = <BookImage>[];
      json['bookInfo']['bookImages'].forEach((v) {
        bookImages!.add(BookImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reservationId'] = reservationId;
    data['userId'] = userId;
    data['reservationDate'] = reservationDate;
    data['status'] = status;
    data['bookId'] = bookId;
    data['bookInfoId'] = bookInfoId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (bookInfo != null) {
      data['bookInfo'] = bookInfo!.toJson();
    }
    if (book != null) {
      data['book'] = book!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (bookImages != null) {
      data['bookImages'] = bookImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class BookImage {
  String? bookImageId;
  String? bookInfoId;
  String? imageUrl;
  bool? isProfile;
  String? createdAt;
  String? updatedAt;

  BookImage(
      {this.bookImageId,
        this.bookInfoId,
        this.imageUrl,
        this.isProfile,
        this.createdAt,
        this.updatedAt,
        });

  BookImage.fromJson(Map<String, dynamic> json) {
    bookImageId = json['bookImageId'];
    bookInfoId = json['bookInfoId'];
    imageUrl = json['imageUrl'];
    isProfile = json['isProfile'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookImageId'] = this.bookImageId;
    data['bookInfoId'] = this.bookInfoId;
    data['imageUrl'] = this.imageUrl;
    data['isProfile'] = this.isProfile;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class BookInfo {
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
  String? publisherId;
  List<BookAuthors>? bookAuthors;
  List<BookGenres>? bookGenres;

  BookInfo(
      {this.bookInfoId,
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
        this.publisherId,
        this.bookAuthors,
        this.bookGenres});

  BookInfo.fromJson(Map<String, dynamic> json) {
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
    publisherId = json['publisherId'];
    if (json['bookAuthors'] != null) {
      bookAuthors = <BookAuthors>[];
      json['bookAuthors'].forEach((v) {
        bookAuthors!.add(new BookAuthors.fromJson(v));
      });
    }
    if (json['bookGenres'] != null) {
      bookGenres = <BookGenres>[];
      json['bookGenres'].forEach((v) {
        bookGenres!.add(new BookGenres.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookInfoId'] = this.bookInfoId;
    data['classNumber'] = this.classNumber;
    data['bookNumber'] = this.bookNumber;
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    data['editionStatement'] = this.editionStatement;
    data['numberOfPages'] = this.numberOfPages;
    data['publicationYear'] = this.publicationYear;
    data['seriesStatement'] = this.seriesStatement;
    data['addedDate'] = this.addedDate;
    data['coverPhoto'] = this.coverPhoto;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['publisherId'] = this.publisherId;
    if (this.bookAuthors != null) {
      data['bookAuthors'] = this.bookAuthors!.map((v) => v.toJson()).toList();
    }
    if (this.bookGenres != null) {
      data['bookGenres'] = this.bookGenres!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookAuthors {
  String? bookAuthorId;
  String? bookInfoId;
  String? authorId;
  String? createdAt;
  String? updatedAt;
  Author? author;

  BookAuthors(
      {this.bookAuthorId,
        this.bookInfoId,
        this.authorId,
        this.createdAt,
        this.updatedAt,
        this.author});

  BookAuthors.fromJson(Map<String, dynamic> json) {
    bookAuthorId = json['bookAuthorId'];
    bookInfoId = json['bookInfoId'];
    authorId = json['authorId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookAuthorId'] = this.bookAuthorId;
    data['bookInfoId'] = this.bookInfoId;
    data['authorId'] = this.authorId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    return data;
  }
}

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

class BookGenres {
  String? bookGenreId;
  String? bookInfoId;
  String? genreId;
  String? createdAt;
  String? updatedAt;
  Genre? genre;

  BookGenres(
      {this.bookGenreId,
        this.bookInfoId,
        this.genreId,
        this.createdAt,
        this.updatedAt,
        this.genre});

  BookGenres.fromJson(Map<String, dynamic> json) {
    bookGenreId = json['bookGenreId'];
    bookInfoId = json['bookInfoId'];
    genreId = json['genreId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    genre = json['genre'] != null ? new Genre.fromJson(json['genre']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookGenreId'] = this.bookGenreId;
    data['bookInfoId'] = this.bookInfoId;
    data['genreId'] = this.genreId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.genre != null) {
      data['genre'] = this.genre!.toJson();
    }
    return data;
  }
}

class Genre {
  String? genreId;
  String? genre;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Genre(
      {this.genreId,
        this.genre,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Genre.fromJson(Map<String, dynamic> json) {
    genreId = json['genreId'];
    genre = json['genre'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genreId'] = this.genreId;
    data['genre'] = this.genre;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}

class Book {
  String? bookId;
  String? barcode;
  String? status;
  String? damagedOn;
  String? bookInfoId;
  String? createdAt;
  String? updatedAt;

  Book(
      {this.bookId,
        this.barcode,
        this.status,
        this.damagedOn,
        this.bookInfoId,
        this.createdAt,
        this.updatedAt});

  Book.fromJson(Map<String, dynamic> json) {
    bookId = json['bookId'];
    barcode = json['barcode'];
    status = json['status'];
    damagedOn = json['damagedOn'];
    bookInfoId = json['bookInfoId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookId'] = this.bookId;
    data['barcode'] = this.barcode;
    data['status'] = this.status;
    data['damagedOn'] = this.damagedOn;
    data['bookInfoId'] = this.bookInfoId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class User {
  String? fullName;
  String? email;
  String? address;
  String? collegeId;
  String? universityId;

  User(
      {this.fullName,
        this.email,
        this.address,
        this.collegeId,
        this.universityId});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    address = json['address'];
    collegeId = json['collegeId'];
    universityId = json['universityId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['address'] = this.address;
    data['collegeId'] = this.collegeId;
    data['universityId'] = this.universityId;
    return data;
  }
}
