import 'dart:convert';

import 'package:library_management_sys/model/publisher_model.dart';

import 'author_model.dart';
import 'genre_model.dart';
import 'isbn_model.dart';

class BookInfoModel {
  final String? bookInfoId;
  final String? classNumber;
  final String? bookNumber;
  final String? title;
  final String? subTitle;
  final String? editionStatement;
  final int? numberOfPages;
  final int? publicationYear;
  final int? total;
  final int? available;
  final String? seriesStatement;
  final String? addedDate;
  final String? coverPhoto;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? publisherId;
  final Publisher? publisher;
  final Score? score;
  final List<BookGenre>? bookGenres;
  final List<BookAuthor>? bookAuthors;
  final List<Isbn>? isbns;
  final List<Book>? books;

  BookInfoModel( {
     this.total,required this.available,
     this.bookInfoId,
     this.classNumber,
     this.bookNumber,
     this.title,
     this.subTitle,
    this.addedDate,
     this.editionStatement,
     this.numberOfPages,
     this.publicationYear,
     this.seriesStatement,
     this.coverPhoto,
     this.createdAt,
     this.updatedAt,
    this.deletedAt,
     this.publisherId,
     this.publisher,
      this.score,
     this.bookGenres,
     this.bookAuthors,
     this.isbns,
     this.books,
  });

  factory BookInfoModel.fromJson(Map<String, dynamic> json) {
    return BookInfoModel(
      bookInfoId: json["bookInfoId"],
      classNumber: json["classNumber"],
      bookNumber: json["bookNumber"],
      title: json["title"],
      subTitle: json["subTitle"],
      editionStatement: json["editionStatement"],
      numberOfPages: json["numberOfPages"],
      publicationYear: json["publicationYear"],
      seriesStatement: json["seriesStatement"],
      addedDate: json["addedDate"],
      coverPhoto: json["coverPhoto"],
      total: json["total"],
      available: json["available"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      deletedAt: json["deletedAt"],
      publisherId: json["publisherId"],
      publisher: Publisher.fromJson(json["publisher"]),
      score: json["score"] != null ? Score.fromJson(json["score"]) :null,
      bookGenres: List<BookGenre>.from(
          json["bookGenres"].map((x) => BookGenre.fromJson(x))),
      bookAuthors: List<BookAuthor>.from(
          json["bookAuthors"].map((x) => BookAuthor.fromJson(x))),
      isbns: List<Isbn>.from(json["isbns"].map((x) => Isbn.fromJson(x))),
      books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bookInfoId": bookInfoId,
      "classNumber": classNumber,
      "bookNumber": bookNumber,
      "title": title,
      "total": total,
      "available": available,
      "subTitle": subTitle,
      "editionStatement": editionStatement,
      "numberOfPages": numberOfPages,
      "publicationYear": publicationYear,
      "seriesStatement": seriesStatement,
      "addedDate": addedDate,
      "coverPhoto": coverPhoto,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "deletedAt": deletedAt,
      "publisherId": publisherId,
      "publisher": publisher!.toJson(),
      "score":score?.toJson(),
      "bookGenres": List<dynamic>.from(bookGenres!.map((x) => x.toJson())),
      "bookAuthors": List<dynamic>.from(bookAuthors!.map((x) => x.toJson())),
      "isbns": List<dynamic>.from(isbns!.map((x) => x.toJson())),
      "books": List<dynamic>.from(books!.map((x) => x.toJson())),
    };
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
class BookGenre {
  final String? bookGenreId;
  final String? bookInfoId;
  final String? genreId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final Genre? genre;

  BookGenre({
     this.bookGenreId,
     this.bookInfoId,
     this.genreId,
     this.createdAt,
     this.updatedAt,
    this.deletedAt,
     this.genre,
  });

  factory BookGenre.fromJson(Map<String, dynamic> json) => BookGenre(
    bookGenreId: json["bookGenreId"],
    bookInfoId: json["bookInfoId"],
    genreId: json["genreId"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    deletedAt: json["deletedAt"],
    genre: Genre.fromJson(json["genre"]),
  );

  Map<String, dynamic> toJson() => {
    "bookGenreId": bookGenreId,
    "bookInfoId": bookInfoId,
    "genreId": genreId,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "deletedAt": deletedAt,
    "genre": genre!.toJson(),
  };
}


class BookAuthor {
  final String? bookAuthorId;
  final String? bookInfoId;
  final String? authorId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final Author? author;

  BookAuthor({
     this.bookAuthorId,
     this.bookInfoId,
     this.authorId,
     this.createdAt,
     this.updatedAt,
    this.deletedAt,
     this.author,
  });

  factory BookAuthor.fromJson(Map<String, dynamic> json) => BookAuthor(
    bookAuthorId: json["bookAuthorId"],
    bookInfoId: json["bookInfoId"],
    authorId: json["authorId"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    deletedAt: json["deletedAt"],
    author: Author.fromJson(json["author"]),
  );

  Map<String, dynamic> toJson() => {
    "bookAuthorId": bookAuthorId,
    "bookInfoId": bookInfoId,
    "authorId": authorId,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "deletedAt": deletedAt,
    "author": author!.toJson(),
  };
}




class Book {
  final String? bookId;
  final String? barcode;
  final String? status;
  final String? damagedOn;
  final String? bookInfoId;

  Book({
     this.bookId,
     this.barcode,
     this.status,
    this.damagedOn,
     this.bookInfoId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['bookId'],
      barcode: json['barcode'],
      status: json['status'],
      damagedOn: json['damagedOn'],
      bookInfoId: json['bookInfoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'barcode': barcode,
      'status': status,
      'damagedOn': damagedOn,
      'bookInfoId': bookInfoId,
    };
  }
}