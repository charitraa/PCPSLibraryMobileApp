class Publisher {
  final String publisherId;
  final String publisherName;
  final String address;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Publisher({
    required this.publisherId,
    required this.publisherName,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) => Publisher(
    publisherId: json["publisherId"],
    publisherName: json["publisherName"],
    address: json["address"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "publisherId": publisherId,
    "publisherName": publisherName,
    "address": address,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "deletedAt": deletedAt,
  };
}