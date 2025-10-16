class UserModel {
  String uid;
  String? fullName;
  String? email;
  String? photoUrl;
  bool emailVerified;
  DateTime? lastSignInTime;
  DateTime? creationTime;

  UserModel({
    required this.uid,
    this.fullName,
    this.email,
    this.photoUrl,
    required this.emailVerified,
    this.lastSignInTime,
    this.creationTime,
  });
}
