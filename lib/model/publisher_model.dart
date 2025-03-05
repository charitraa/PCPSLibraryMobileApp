class Publisher {
  final String? publisherId;
  final String? publisherName;
  final String? address;
  final String? createdAt;
  final String? updatedAt;

  Publisher({
     this.publisherId,
     this.publisherName,
     this.address,
     this.createdAt,
     this.updatedAt,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) => Publisher(
    publisherId: json["publisherId"],
    publisherName: json["publisherName"],
    address: json["address"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "publisherId": publisherId,
    "publisherName": publisherName,
    "address": address,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}