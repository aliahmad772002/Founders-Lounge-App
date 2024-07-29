class UserModel {
  final String? uname;
  final String? profession;
  final String? phone;
  final String? email;
  final String? profileImage;
  final String? password;
  final String? cnfpwd;
  final String? uid;
  final String? tokenID; // Add this line
  final List<String>? followers;
  final List<String>? following;
  final List<String>? posts;

  const UserModel({
    this.uname,
    this.profession,
    this.phone,
    this.email,
    this.profileImage,
    this.password,
    this.cnfpwd,
    this.uid,
    this.tokenID, // Add this line
    this.followers,
    this.following,
    this.posts,
  });

  // ... existing methods ...

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uname: map['uname'],
      profession: map['profession'],
      phone: map['phone'],
      email: map['email'],
      profileImage: map['profileImage'],
      password: map['password'],
      cnfpwd: map['cnfpwd'],
      uid: map['uid'],
      tokenID: map['tokenID'], // Add this line
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      posts: List<String>.from(map['posts'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uname': uname,
      'profession': profession,
      'phone': phone,
      'email': email,
      'profileImage': profileImage,
      'password': password,
      'cnfpwd': cnfpwd,
      'uid': uid,
      'tokenID': tokenID, // Add this line
      'followers': followers,
      'following': following,
      'posts': posts,
    };
  }
}
