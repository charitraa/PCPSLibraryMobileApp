class UserModel {
  String? userId;
  String? fullName;
  String? session;
  String? cardId;
  String? profilePicUrl;
  String? roleId;
  String? membershipValidUntil;
  String? createdAt;
  String? updatedAt;
  Role? role;

  UserModel(
      {this.userId,
        this.fullName,
        this.session,
        this.cardId,
        this.profilePicUrl,
        this.roleId,
        this.membershipValidUntil,
        this.createdAt,
        this.updatedAt,
        this.role});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    session = json['session'];
    cardId = json['cardId'];
    profilePicUrl = json['profilePicUrl'];
    roleId = json['roleId'];
    membershipValidUntil = json['membershipValidUntil'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['session'] = this.session;
    data['cardId'] = this.cardId;
    data['profilePicUrl'] = this.profilePicUrl;
    data['roleId'] = this.roleId;
    data['membershipValidUntil'] = this.membershipValidUntil;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    return data;
  }
}

class Role {
  String? roleId;
  String? role;
  int? precedence;

  Role({this.roleId, this.role, this.precedence});

  Role.fromJson(Map<String, dynamic> json) {
    roleId = json['roleId'];
    role = json['role'];
    precedence = json['precedence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roleId'] = this.roleId;
    data['role'] = this.role;
    data['precedence'] = this.precedence;
    return data;
  }
}
