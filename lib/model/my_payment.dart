class PaymentModel {
  String? paymentId;
  int? amountPaid;
  String? paymentType;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? userId;

  PaymentModel(
      {this.paymentId,
        this.amountPaid,
        this.paymentType,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.userId});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    amountPaid = json['amountPaid'];
    paymentType = json['paymentType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentId'] = this.paymentId;
    data['amountPaid'] = this.amountPaid;
    data['paymentType'] = this.paymentType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['userId'] = this.userId;
    return data;
  }
}
