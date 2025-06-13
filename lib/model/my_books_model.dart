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
  String? createdAt;
  String? updatedAt;
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
        this.createdAt,
        this.updatedAt,
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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
  String? damagedOn;
  bool? isReference;
  String? bookInfoId;
  String? createdAt;
  String? updatedAt;
  BookInfo? bookInfo;

  Book(
      {this.bookId,
        this.barcode,
        this.status,
        this.damagedOn,
        this.isReference,
        this.bookInfoId,
        this.createdAt,
        this.updatedAt,
        this.bookInfo});

  Book.fromJson(Map<String, dynamic> json) {
    bookId = json['bookId'];
    barcode = json['barcode'];
    status = json['status'];
    damagedOn = json['damagedOn'];
    isReference = json['isReference'];
    bookInfoId = json['bookInfoId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    data['isReference'] = this.isReference;
    data['bookInfoId'] = this.bookInfoId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.bookInfo != null) {
      data['bookInfo'] = this.bookInfo!.toJson();
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
  String? coverPhoto;
  int? numberOfPages;
  int? publicationYear;
  String? seriesStatement;
  String? addedDate;
  String? createdAt;
  String? updatedAt;
  String? publisherId;

  BookInfo(
      {this.bookInfoId,
        this.classNumber,
        this.title,
        this.subTitle,
        this.editionStatement,
        this.coverPhoto,
        this.numberOfPages,
        this.publicationYear,
        this.seriesStatement,
        this.addedDate,
        this.createdAt,
        this.updatedAt,
        this.publisherId});

  BookInfo.fromJson(Map<String, dynamic> json) {
    bookInfoId = json['bookInfoId'];
    classNumber = json['classNumber'];
    title = json['title'];
    subTitle = json['subTitle'];
    editionStatement = json['editionStatement'];
    coverPhoto = json['coverPhoto'];
    numberOfPages = json['numberOfPages'];
    publicationYear = json['publicationYear'];
    seriesStatement = json['seriesStatement'];
    addedDate = json['addedDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    publisherId = json['publisherId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookInfoId'] = this.bookInfoId;
    data['classNumber'] = this.classNumber;
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    data['editionStatement'] = this.editionStatement;
    data['coverPhoto'] = this.coverPhoto;
    data['numberOfPages'] = this.numberOfPages;
    data['publicationYear'] = this.publicationYear;
    data['seriesStatement'] = this.seriesStatement;
    data['addedDate'] = this.addedDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['publisherId'] = this.publisherId;
    return data;
  }
}
