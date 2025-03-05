import 'dart:convert';

import 'package:library_management_sys/model/author_model.dart';
import 'package:library_management_sys/model/genre_model.dart';
import 'package:library_management_sys/model/isbn_model.dart';
import 'package:library_management_sys/model/publisher_model.dart';

class BooksModel {
  final String? bookInfoId;
  final String? classNumber;
  final String? bookNumber;
  final String? title;
  final String? subTitle;
  final String? editionStatement;
  final int? numberOfPages;
  final int? publicationYear;
  final String? seriesStatement;
  final String? addedDate;
  final String? coverPhoto;
  final String? createdAt;
  final String? updatedAt;
  final String? publisherId;
  final Publisher? publisher;
  final List<dynamic>? score;
  final List<BookGenre>? bookGenres;
  final List<BookAuthor>? bookAuthors;
  final List<Isbn>? isbns;
  final List<Book>? books;

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
    this.publisherId,
    this.publisher,
    this.score,
    this.bookGenres,
    this.bookAuthors,
    this.isbns,
    this.books,
  });

  factory BooksModel.fromJson(Map<String, dynamic> json) {
    return BooksModel(
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
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      publisherId: json["publisherId"],
      publisher: json["publisher"] != null ? Publisher.fromJson(json["publisher"]) : null,
      score: json["score"] != null ? List<dynamic>.from(json["score"]) : [],
      bookGenres: json["bookGenres"] != null
          ? List<BookGenre>.from(json["bookGenres"].map((x) => BookGenre.fromJson(x)))
          : [],
      bookAuthors: json["bookAuthors"] != null
          ? List<BookAuthor>.from(json["bookAuthors"].map((x) => BookAuthor.fromJson(x)))
          : [],
      isbns: json["isbns"] != null ? List<Isbn>.from(json["isbns"].map((x) => Isbn.fromJson(x))) : [],
      books: json["books"] != null ? List<Book>.from(json["books"].map((x) => Book.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bookInfoId": bookInfoId,
      "classNumber": classNumber,
      "bookNumber": bookNumber,
      "title": title,
      "subTitle": subTitle,
      "editionStatement": editionStatement,
      "numberOfPages": numberOfPages,
      "publicationYear": publicationYear,
      "seriesStatement": seriesStatement,
      "addedDate": addedDate,
      "coverPhoto": coverPhoto,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "publisherId": publisherId,
      "publisher": publisher?.toJson(),
      "score": score ?? [],
      "bookGenres": bookGenres?.map((x) => x.toJson()).toList() ?? [],
      "bookAuthors": bookAuthors?.map((x) => x.toJson()).toList() ?? [],
      "isbns": isbns?.map((x) => x.toJson()).toList() ?? [],
      "books": books?.map((x) => x.toJson()).toList() ?? [],
    };
  }
}

class BookGenre {
  final String? bookGenreId;
  final String? bookInfoId;
  final String? genreId;
  final String? createdAt;
  final String? updatedAt;
  final Genre? genre;

  BookGenre({
    this.bookGenreId,
    this.bookInfoId,
    this.genreId,
    this.createdAt,
    this.updatedAt,
    this.genre,
  });

  factory BookGenre.fromJson(Map<String, dynamic> json) => BookGenre(
    bookGenreId: json["bookGenreId"],
    bookInfoId: json["bookInfoId"],
    genreId: json["genreId"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    genre: json["genre"] != null ? Genre.fromJson(json["genre"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "bookGenreId": bookGenreId,
    "bookInfoId": bookInfoId,
    "genreId": genreId,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "genre": genre?.toJson(),
  };
}


class BookAuthor {
  final String? bookAuthorId;
  final String? bookInfoId;
  final String? authorId;
  final String? createdAt;
  final String? updatedAt;
  final Author? author;

  BookAuthor({
     this.bookAuthorId,
     this.bookInfoId,
     this.authorId,
     this.createdAt,
     this.updatedAt,
     this.author,
  });

  factory BookAuthor.fromJson(Map<String, dynamic> json) => BookAuthor(
    bookAuthorId: json["bookAuthorId"],
    bookInfoId: json["bookInfoId"],
    authorId: json["authorId"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    author: Author.fromJson(json["author"]),
  );

  Map<String, dynamic> toJson() => {
    "bookAuthorId": bookAuthorId,
    "bookInfoId": bookInfoId,
    "authorId": authorId,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "author": author?.toJson(),
  };
}

class Book {
  final String? bookId;
  final String? barcode;
  final String? status;
  final String? bookInfoId;

  Book({
     this.bookId,
     this.barcode,
     this.status,
     this.bookInfoId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['bookId'],
      barcode: json['barcode'],
      status: json['status'],
      bookInfoId: json['bookInfoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'barcode': barcode,
      'status': status,
      'bookInfoId': bookInfoId,
    };
  }
}