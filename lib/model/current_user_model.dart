class CurrentUserModel {
  String? userId;
  String? fullName;
  String? dob;
  String? address;
  String? contactNo;
  String? universityId;
  String? collegeId;
  String? profilePicUrl;
  String? accountCreationDate;
  String? enrollmentYear;
  String? gender;
  String? roleId;
  String? email;
  String? accountStatus;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Role? role;
  Membership? membership;

  CurrentUserModel({
    this.userId,
    this.fullName,
    this.dob,
    this.address,
    this.contactNo,
    this.universityId,
    this.collegeId,
    this.profilePicUrl,
    this.accountCreationDate,
    this.enrollmentYear,
    this.gender,
    this.roleId,
    this.email,
    this.accountStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.role,
    this.membership,
  });

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserModel(
      userId: json['userId'],
      fullName: json['fullName'],
      dob: json['dob'],
      address: json['address'],
      contactNo: json['contactNo'],
      universityId: json['universityId'],
      collegeId: json['collegeId'],
      profilePicUrl: json['profilePicUrl'],
      accountCreationDate: json['accountCreationDate'],
      enrollmentYear: json['enrollmentYear'],
      gender: json['gender'],
      roleId: json['roleId'],
      email: json['email'],
      accountStatus: json['accountStatus'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      membership: json['membership'] != null ? Membership.fromJson(json['membership']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['fullName'] = fullName;
    data['dob'] = dob;
    data['address'] = address;
    data['contactNo'] = contactNo;
    data['universityId'] = universityId;
    data['collegeId'] = collegeId;
    data['profilePicUrl'] = profilePicUrl;
    data['accountCreationDate'] = accountCreationDate;
    data['enrollmentYear'] = enrollmentYear;
    data['gender'] = gender;
    data['roleId'] = roleId;
    data['email'] = email;
    data['accountStatus'] = accountStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    if (membership != null) {
      data['membership'] = membership!.toJson();
    }
    return data;
  }
}

class Role {
  String? roleId;
  String? role;
  int? precedence;
  String? deletedAt;

  Role({this.roleId, this.role, this.precedence, this.deletedAt});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['roleId'],
      role: json['role'],
      precedence: json['precedence'],
      deletedAt: json['deletedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
      'role': role,
      'precedence': precedence,
      'deletedAt': deletedAt,
    };
  }
}

class Membership {
  String? membershipId;
  String? startDate;
  String? expiryDate;
  int? renewalCount;
  String? lastRenewalDate;
  String? status;
  String? membershipTypeId;
  String? userId;
  String? deletedAt;

  Membership({
    this.membershipId,
    this.startDate,
    this.expiryDate,
    this.renewalCount,
    this.lastRenewalDate,
    this.status,
    this.membershipTypeId,
    this.userId,
    this.deletedAt,
  });

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      membershipId: json['membershipId'],
      startDate: json['startDate'],
      expiryDate: json['expiryDate'],
      renewalCount: json['renewalCount'],
      lastRenewalDate: json['lastRenewalDate'],
      status: json['status'],
      membershipTypeId: json['membershipTypeId'],
      userId: json['userId'],
      deletedAt: json['deletedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membershipId': membershipId,
      'startDate': startDate,
      'expiryDate': expiryDate,
      'renewalCount': renewalCount,
      'lastRenewalDate': lastRenewalDate,
      'status': status,
      'membershipTypeId': membershipTypeId,
      'userId': userId,
      'deletedAt': deletedAt,
    };
  }
}
