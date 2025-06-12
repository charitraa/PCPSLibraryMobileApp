class UserModel {
  String? userId;
  String? fullName;
  String? cardId;
  String? profilePicUrl;
  String? session;
  String? roleId;
  String? membershipValidUntil;
  Role? role;

  UserModel(
      {this.userId,
        this.fullName,
        this.cardId,
        this.profilePicUrl,
        this.session,
        this.roleId,
        this.membershipValidUntil,
        this.role});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    cardId = json['cardId'];
    profilePicUrl = json['profilePicUrl'];
    session = json['session'];
    roleId = json['roleId'];
    membershipValidUntil = json['membershipValidUntil'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['cardId'] = this.cardId;
    data['profilePicUrl'] = this.profilePicUrl;
    data['session'] = this.session;
    data['roleId'] = this.roleId;
    data['membershipValidUntil'] = this.membershipValidUntil;
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
