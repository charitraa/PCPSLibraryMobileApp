class UserModel {
  String? userId;
  String? fullName;
  String? dob;
  String? address;
  String? contactNo;
  String? profilePicUrl;
  String? accountCreationDate;
  String? enrollMentYear;
  String? gender;
  String? roleId;
  String? role;
  String? membershipId;
  String? membership;
  String? rollNumber;
  String? email;
  String? accountStatus;
  String? session;

  UserModel(
      {this.userId,
        this.fullName,
        this.dob,
        this.address,
        this.contactNo,
        this.profilePicUrl,
        this.accountCreationDate,
        this.enrollMentYear,
        this.gender,
        this.roleId,
        this.role,
        this.membershipId,
        this.membership,
        this.rollNumber,
        this.email,
        this.accountStatus,
        this.session});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    dob = json['dob'];
    address = json['address'];
    contactNo = json['contactNo'];
    profilePicUrl = json['profilePicUrl'];
    accountCreationDate = json['accountCreationDate'];
    enrollMentYear = json['enrollMentYear'];
    gender = json['gender'];
    roleId = json['roleId'];
    role = json['role'];
    membershipId = json['membershipId'];
    membership = json['membership'];
    rollNumber = json['rollNumber'];
    email = json['email'];
    accountStatus = json['accountStatus'];
    session = json['session'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['contactNo'] = this.contactNo;
    data['profilePicUrl'] = this.profilePicUrl;
    data['accountCreationDate'] = this.accountCreationDate;
    data['enrollMentYear'] = this.enrollMentYear;
    data['gender'] = this.gender;
    data['roleId'] = this.roleId;
    data['role'] = this.role;
    data['membershipId'] = this.membershipId;
    data['membership'] = this.membership;
    data['rollNumber'] = this.rollNumber;
    data['email'] = this.email;
    data['accountStatus'] = this.accountStatus;
    data['session'] = this.session;
    return data;
  }
}
