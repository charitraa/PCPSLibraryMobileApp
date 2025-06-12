class BooksModel {
  String? bookInfoId;
  String? classNumber;
  String? title;
  String? subTitle;
  String? editionStatement;
  int? numberOfPages;
  int? publicationYear;
  String? seriesStatement;
  String? addedDate;
  String? createdAt;
  String? publisherId;
  Publisher? publisher;
  Score? score;
  List<BookImages>? bookImages;
  List<BookKeywords>? bookKeywords;
  List<BookGenres>? bookGenres;
  List<BookAuthors>? bookAuthors;
  List<Isbns>? isbns;
  List<Books>? books;

  BooksModel(
      {this.bookInfoId,
        this.classNumber,
        this.title,
        this.subTitle,
        this.editionStatement,
        this.numberOfPages,
        this.publicationYear,
        this.seriesStatement,
        this.addedDate,
        this.createdAt,
        this.publisherId,
        this.publisher,
        this.score,
        this.bookImages,
        this.bookKeywords,
        this.bookGenres,
        this.bookAuthors,
        this.isbns,
        this.books});

  BooksModel.fromJson(Map<String, dynamic> json) {
    bookInfoId = json['bookInfoId'];
    classNumber = json['classNumber'];
    title = json['title'];
    subTitle = json['subTitle'];
    editionStatement = json['editionStatement'];
    numberOfPages = json['numberOfPages'];
    publicationYear = json['publicationYear'];
    seriesStatement = json['seriesStatement'];
    addedDate = json['addedDate'];
    createdAt = json['createdAt'];
    publisherId = json['publisherId'];
    publisher = json['publisher'] != null
        ? new Publisher.fromJson(json['publisher'])
        : null;
    score = json['score'] != null ? new Score.fromJson(json['score']) : null;
    if (json['bookImages'] != null) {
      bookImages = <BookImages>[];
      json['bookImages'].forEach((v) {
        bookImages!.add(new BookImages.fromJson(v));
      });
    }
    if (json['bookKeywords'] != null) {
      bookKeywords = <BookKeywords>[];
      json['bookKeywords'].forEach((v) {
        bookKeywords!.add(new BookKeywords.fromJson(v));
      });
    }
    if (json['bookGenres'] != null) {
      bookGenres = <BookGenres>[];
      json['bookGenres'].forEach((v) {
        bookGenres!.add(new BookGenres.fromJson(v));
      });
    }
    if (json['bookAuthors'] != null) {
      bookAuthors = <BookAuthors>[];
      json['bookAuthors'].forEach((v) {
        bookAuthors!.add(new BookAuthors.fromJson(v));
      });
    }
    if (json['isbns'] != null) {
      isbns = <Isbns>[];
      json['isbns'].forEach((v) {
        isbns!.add(new Isbns.fromJson(v));
      });
    }
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(new Books.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookInfoId'] = this.bookInfoId;
    data['classNumber'] = this.classNumber;
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    data['editionStatement'] = this.editionStatement;
    data['numberOfPages'] = this.numberOfPages;
    data['publicationYear'] = this.publicationYear;
    data['seriesStatement'] = this.seriesStatement;
    data['addedDate'] = this.addedDate;
    data['createdAt'] = this.createdAt;
    data['publisherId'] = this.publisherId;
    if (this.publisher != null) {
      data['publisher'] = this.publisher!.toJson();
    }
    if (this.score != null) {
      data['score'] = this.score!.toJson();
    }
    if (this.bookImages != null) {
      data['bookImages'] = this.bookImages!.map((v) => v.toJson()).toList();
    }
    if (this.bookKeywords != null) {
      data['bookKeywords'] = this.bookKeywords!.map((v) => v.toJson()).toList();
    }
    if (this.bookGenres != null) {
      data['bookGenres'] = this.bookGenres!.map((v) => v.toJson()).toList();
    }
    if (this.bookAuthors != null) {
      data['bookAuthors'] = this.bookAuthors!.map((v) => v.toJson()).toList();
    }
    if (this.isbns != null) {
      data['isbns'] = this.isbns!.map((v) => v.toJson()).toList();
    }
    if (this.books != null) {
      data['books'] = this.books!.map((v) => v.toJson()).toList();
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

  Publisher(
      {this.publisherId,
        this.publisherName,
        this.address,
        this.createdAt,
        this.updatedAt});

  Publisher.fromJson(Map<String, dynamic> json) {
    publisherId = json['publisherId'];
    publisherName = json['publisherName'];
    address = json['address'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publisherId'] = this.publisherId;
    data['publisherName'] = this.publisherName;
    data['address'] = this.address;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Score {
  String? bookRatingScoreId;
  String? bookInfoId;
  int? score;

  Score({this.bookRatingScoreId, this.bookInfoId, this.score});

  Score.fromJson(Map<String, dynamic> json) {
    bookRatingScoreId = json['bookRatingScoreId'];
    bookInfoId = json['bookInfoId'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookRatingScoreId'] = this.bookRatingScoreId;
    data['bookInfoId'] = this.bookInfoId;
    data['score'] = this.score;
    return data;
  }
}

class BookImages {
  String? bookImageId;
  String? bookInfoId;
  String? imageUrl;
  bool? isProfile;
  String? createdAt;
  String? updatedAt;

  BookImages(
      {this.bookImageId,
        this.bookInfoId,
        this.imageUrl,
        this.isProfile,
        this.createdAt,
        this.updatedAt});

  BookImages.fromJson(Map<String, dynamic> json) {
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

class BookKeywords {
  String? bookInfoId;
  String? keywordId;
  String? createdAt;
  String? updatedAt;
  Keyword? keyword;

  BookKeywords(
      {this.bookInfoId,
        this.keywordId,
        this.createdAt,
        this.updatedAt,
        this.keyword});

  BookKeywords.fromJson(Map<String, dynamic> json) {
    bookInfoId = json['bookInfoId'];
    keywordId = json['keywordId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    keyword =
    json['keyword'] != null ? new Keyword.fromJson(json['keyword']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookInfoId'] = this.bookInfoId;
    data['keywordId'] = this.keywordId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.keyword != null) {
      data['keyword'] = this.keyword!.toJson();
    }
    return data;
  }
}

class Keyword {
  String? keywordId;
  String? keyword;
  String? createdAt;
  String? updatedAt;

  Keyword({this.keywordId, this.keyword, this.createdAt, this.updatedAt});

  Keyword.fromJson(Map<String, dynamic> json) {
    keywordId = json['keywordId'];
    keyword = json['keyword'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keywordId'] = this.keywordId;
    data['keyword'] = this.keyword;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class BookGenres {
  String? bookInfoId;
  String? genreId;
  String? createdAt;
  String? updatedAt;
  Genre? genre;

  BookGenres(
      {this.bookInfoId,
        this.genreId,
        this.createdAt,
        this.updatedAt,
        this.genre});

  BookGenres.fromJson(Map<String, dynamic> json) {
    bookInfoId = json['bookInfoId'];
    genreId = json['genreId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    genre = json['genre'] != null ? new Genre.fromJson(json['genre']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

  Genre({this.genreId, this.genre, this.createdAt, this.updatedAt});

  Genre.fromJson(Map<String, dynamic> json) {
    genreId = json['genreId'];
    genre = json['genre'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genreId'] = this.genreId;
    data['genre'] = this.genre;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class BookAuthors {
  String? bookInfoId;
  String? authorId;
  String? createdAt;
  String? updatedAt;
  Author? author;

  BookAuthors(
      {this.bookInfoId,
        this.authorId,
        this.createdAt,
        this.updatedAt,
        this.author});

  BookAuthors.fromJson(Map<String, dynamic> json) {
    bookInfoId = json['bookInfoId'];
    authorId = json['authorId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class Isbns {
  String? isbnId;
  String? isbn;
  String? bookInfoId;
  String? createdAt;
  String? updatedAt;

  Isbns(
      {this.isbnId,
        this.isbn,
        this.bookInfoId,
        this.createdAt,
        this.updatedAt});

  Isbns.fromJson(Map<String, dynamic> json) {
    isbnId = json['isbnId'];
    isbn = json['isbn'];
    bookInfoId = json['bookInfoId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isbnId'] = this.isbnId;
    data['isbn'] = this.isbn;
    data['bookInfoId'] = this.bookInfoId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Books {
  String? bookId;
  String? barcode;
  String? status;
  Null? damagedOn;
  bool? isReference;
  String? bookInfoId;
  String? createdAt;

  Books(
      {this.bookId,
        this.barcode,
        this.status,
        this.damagedOn,
        this.isReference,
        this.bookInfoId,
        this.createdAt});

  Books.fromJson(Map<String, dynamic> json) {
    bookId = json['bookId'];
    barcode = json['barcode'];
    status = json['status'];
    damagedOn = json['damagedOn'];
    isReference = json['isReference'];
    bookInfoId = json['bookInfoId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookId'] = this.bookId;
    data['barcode'] = this.barcode;
    data['status'] = this.status;
    data['damagedOn'] = this.damagedOn;
    data['isReference'] = this.isReference;
    data['bookInfoId'] = this.bookInfoId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
