class ReservationModel {
  String? reservationId;
  String? userId;
  String? reservationDate;
  String? status;
  String? bookId;
  String? bookInfoId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  BookInfo? bookInfo;
  Book? book;
  User? user;

  ReservationModel(
      {this.reservationId,
        this.userId,
        this.reservationDate,
        this.status,
        this.bookId,
        this.bookInfoId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.bookInfo,
        this.book,
        this.user});

  ReservationModel.fromJson(Map<String, dynamic> json) {
    reservationId = json['reservationId'];
    userId = json['userId'];
    reservationDate = json['reservationDate'];
    status = json['status'];
    bookId = json['bookId'];
    bookInfoId = json['bookInfoId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    bookInfo = json['bookInfo'] != null
        ? new BookInfo.fromJson(json['bookInfo'])
        : null;
    book = json['book'] != null ? new Book.fromJson(json['book']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reservationId'] = this.reservationId;
    data['userId'] = this.userId;
    data['reservationDate'] = this.reservationDate;
    data['status'] = this.status;
    data['bookId'] = this.bookId;
    data['bookInfoId'] = this.bookInfoId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    if (this.bookInfo != null) {
      data['bookInfo'] = this.bookInfo!.toJson();
    }
    if (this.book != null) {
      data['book'] = this.book!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class BookInfo {
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
  String? updatedAt;
  String? deletedAt;
  String? publisherId;
  List<BookImages>? bookImages;

  BookInfo(
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
        this.updatedAt,
        this.deletedAt,
        this.publisherId,
        this.bookImages});

  BookInfo.fromJson(Map<String, dynamic> json) {
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
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    publisherId = json['publisherId'];
    if (json['bookImages'] != null) {
      bookImages = <BookImages>[];
      json['bookImages'].forEach((v) {
        bookImages!.add(new BookImages.fromJson(v));
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
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['publisherId'] = this.publisherId;
    if (this.bookImages != null) {
      data['bookImages'] = this.bookImages!.map((v) => v.toJson()).toList();
    }
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
  String? deletedAt;

  BookImages(
      {this.bookImageId,
        this.bookInfoId,
        this.imageUrl,
        this.isProfile,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  BookImages.fromJson(Map<String, dynamic> json) {
    bookImageId = json['bookImageId'];
    bookInfoId = json['bookInfoId'];
    imageUrl = json['imageUrl'];
    isProfile = json['isProfile'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookImageId'] = this.bookImageId;
    data['bookInfoId'] = this.bookInfoId;
    data['imageUrl'] = this.imageUrl;
    data['isProfile'] = this.isProfile;
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
  bool? isReference;
  String? bookInfoId;
  String? createdAt;
  String? updatedAt;

  Book(
      {this.bookId,
        this.barcode,
        this.status,
        this.damagedOn,
        this.isReference,
        this.bookInfoId,
        this.createdAt,
        this.updatedAt,
        });

  Book.fromJson(Map<String, dynamic> json) {
    bookId = json['bookId'];
    barcode = json['barcode'];
    status = json['status'];
    damagedOn = json['damagedOn'];
    isReference = json['isReference'];
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
    data['isReference'] = this.isReference;
    data['bookInfoId'] = this.bookInfoId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class User {
  String? userId;
  String? cardId;
  String? fullName;
  String? profilePicUrl;

  User({this.userId, this.cardId, this.fullName, this.profilePicUrl});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    cardId = json['cardId'];
    fullName = json['fullName'];
    profilePicUrl = json['profilePicUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['cardId'] = this.cardId;
    data['fullName'] = this.fullName;
    data['profilePicUrl'] = this.profilePicUrl;
    return data;
  }
}
