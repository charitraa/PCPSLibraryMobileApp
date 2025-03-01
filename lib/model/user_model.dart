class UserModel {
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
  String? session;
  String? rollNumber;
  String? email;
  String? accountStatus;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  UserModel(
      {this.userId,
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
        this.session,
        this.rollNumber,
        this.email,
        this.accountStatus,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    dob = json['dob'];
    address = json['address'];
    contactNo = json['contactNo'];
    universityId = json['universityId'];
    collegeId = json['collegeId'];
    profilePicUrl = json['profilePicUrl'];
    accountCreationDate = json['accountCreationDate'];
    enrollmentYear = json['enrollmentYear'];
    gender = json['gender'];
    roleId = json['roleId'];
    session = json['session'];
    rollNumber = json['rollNumber'];
    email = json['email'];
    accountStatus = json['accountStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['contactNo'] = this.contactNo;
    data['universityId'] = this.universityId;
    data['collegeId'] = this.collegeId;
    data['profilePicUrl'] = this.profilePicUrl;
    data['accountCreationDate'] = this.accountCreationDate;
    data['enrollmentYear'] = this.enrollmentYear;
    data['gender'] = this.gender;
    data['roleId'] = this.roleId;
    data['session'] = this.session;
    data['rollNumber'] = this.rollNumber;
    data['email'] = this.email;
    data['accountStatus'] = this.accountStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
