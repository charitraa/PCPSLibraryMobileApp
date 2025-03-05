class Isbn {
  final String? isbnId;
  final String? isbn;
  final String? bookInfoId;

  Isbn({
     this.isbnId,
     this.isbn,
     this.bookInfoId,
  });

  factory Isbn.fromJson(Map<String, dynamic> json) {
    return Isbn(
      isbnId: json['isbnId'],
      isbn: json['isbn'],
      bookInfoId: json['bookInfoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isbnId': isbnId,
      'isbn': isbn,
      'bookInfoId': bookInfoId,
    };
  }
}