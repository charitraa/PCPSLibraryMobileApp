class DueModel {
  String? penaltyId;
  String? description;
  int? amount;
  String? status;
  String? penaltyType;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? userId;

  DueModel(
      {this.penaltyId,
        this.description,
        this.amount,
        this.status,
        this.penaltyType,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.userId});

  DueModel.fromJson(Map<String, dynamic> json) {
    penaltyId = json['penaltyId'];
    description = json['description'];
    amount = json['amount'];
    status = json['status'];
    penaltyType = json['penaltyType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['penaltyId'] = this.penaltyId;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['penaltyType'] = this.penaltyType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['userId'] = this.userId;
    return data;
  }
}
