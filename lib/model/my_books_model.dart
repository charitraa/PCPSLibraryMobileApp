class MyBooksModel {
  String? issueId;
  String? checkInDate;
  String? checkOutDate;
  String? dueDate;
  String? lastRenewedAt;
  int? renewalCount;
  String? status;
  String? bookId;
  String? userId;
  String? issuedBy;
  Book? book;

  MyBooksModel(
      {this.issueId,
        this.checkInDate,
        this.checkOutDate,
        this.dueDate,
        this.lastRenewedAt,
        this.renewalCount,
        this.status,
        this.bookId,
        this.userId,
        this.issuedBy,
        this.book});

  MyBooksModel.fromJson(Map<String, dynamic> json) {
    issueId = json['issueId'];
    checkInDate = json['checkInDate'];
    checkOutDate = json['checkOutDate'];
    dueDate = json['dueDate'];
    lastRenewedAt = json['lastRenewedAt'];
    renewalCount = json['renewalCount'];
    status = json['status'];
    bookId = json['bookId'];
    userId = json['userId'];
    issuedBy = json['issuedBy'];
    book = json['book'] != null ? new Book.fromJson(json['book']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['issueId'] = this.issueId;
    data['checkInDate'] = this.checkInDate;
    data['checkOutDate'] = this.checkOutDate;
    data['dueDate'] = this.dueDate;
    data['lastRenewedAt'] = this.lastRenewedAt;
    data['renewalCount'] = this.renewalCount;
    data['status'] = this.status;
    data['bookId'] = this.bookId;
    data['userId'] = this.userId;
    data['issuedBy'] = this.issuedBy;
    if (this.book != null) {
      data['book'] = this.book!.toJson();
    }
    return data;
  }
}

class Book {
  String? bookId;
  String? barcode;
  String? status;
  Null? damagedOn;
  String? bookInfoId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  BookInfo? bookInfo;

  Book(
      {this.bookId,
        this.barcode,
        this.status,
        this.damagedOn,
        this.bookInfoId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.bookInfo});

  Book.fromJson(Map<String, dynamic> json) {
    bookId = json['bookId'];
    barcode = json['barcode'];
    status = json['status'];
    damagedOn = json['damagedOn'];
    bookInfoId = json['bookInfoId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    bookInfo = json['bookInfo'] != null
        ? new BookInfo.fromJson(json['bookInfo'])
        : null;
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
    data['deletedAt'] = this.deletedAt;
    if (this.bookInfo != null) {
      data['bookInfo'] = this.bookInfo!.toJson();
    }
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
  String? deletedAt;
  String? publisherId;

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
        this.deletedAt,
        this.publisherId});

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
    deletedAt = json['deletedAt'];
    publisherId = json['publisherId'];
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
    data['deletedAt'] = this.deletedAt;
    data['publisherId'] = this.publisherId;
    return data;
  }
}
