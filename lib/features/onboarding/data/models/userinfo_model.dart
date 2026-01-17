class UserInfoModel {
  final int userId;
  final String userName;
  final bool isSuperUser;
  final bool isStaff;

  UserInfoModel({
    required this.userId,
    required this.userName,
    required this.isSuperUser,
    required this.isStaff,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      userId: json['id'],
      userName: json['name'],
      isSuperUser: json['is_superuser'],
      isStaff: json['is_staff'],
    );
  }
}