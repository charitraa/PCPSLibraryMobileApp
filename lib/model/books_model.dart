import 'dart:convert';

import 'package:library_management_sys/model/publisher_model.dart';

import 'author_model.dart';
import 'genre_model.dart';
import 'isbn_model.dart';

class BooksModel {
  final String bookInfoId;
  final String classNumber;
  final String bookNumber;
  final String title;
  final String subTitle;
  final String editionStatement;
  final int numberOfPages;
  final int publicationYear;
  final String seriesStatement;
  final String addedDate;
  final String coverPhoto;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String publisherId;
  final Publisher publisher;
  final List<dynamic> score;
  final List<BookGenre> bookGenres;
  final List<BookAuthor> bookAuthors;
  final List<Isbn> isbns;
  final List<Book> books;

  BooksModel({
    required this.bookInfoId,
    required this.classNumber,
    required this.bookNumber,
    required this.title,
    required this.subTitle,
    required this.editionStatement,
    required this.numberOfPages,
    required this.publicationYear,
    required this.seriesStatement,
    required this.addedDate,
    required this.coverPhoto,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.publisherId,
    required this.publisher,
    required this.score,
    required this.bookGenres,
    required this.bookAuthors,
    required this.isbns,
    required this.books,
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
      deletedAt: json["deletedAt"],
      publisherId: json["publisherId"],
      publisher: Publisher.fromJson(json["publisher"]),
      score: List<dynamic>.from(json["score"] ?? []),
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
      "publisher": publisher.toJson(),
      "score": score,
      "bookGenres": List<dynamic>.from(bookGenres.map((x) => x.toJson())),
      "bookAuthors": List<dynamic>.from(bookAuthors.map((x) => x.toJson())),
      "isbns": List<dynamic>.from(isbns.map((x) => x.toJson())),
      "books": List<dynamic>.from(books.map((x) => x.toJson())),
    };
  }
}


class BookGenre {
  final String bookGenreId;
  final String bookInfoId;
  final String genreId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final Genre genre;

  BookGenre({
    required this.bookGenreId,
    required this.bookInfoId,
    required this.genreId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.genre,
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
    "genre": genre.toJson(),
  };
}


class BookAuthor {
  final String bookAuthorId;
  final String bookInfoId;
  final String authorId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final Author author;

  BookAuthor({
    required this.bookAuthorId,
    required this.bookInfoId,
    required this.authorId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.author,
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
    "author": author.toJson(),
  };
}




class Book {
  final String bookId;
  final String barcode;
  final String status;
  final String? damagedOn;
  final String bookInfoId;

  Book({
    required this.bookId,
    required this.barcode,
    required this.status,
    this.damagedOn,
    required this.bookInfoId,
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