// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LikeModel {
  String? like;
  String? likeID;
  String? postID;
  String? uname;
  String? email;
  String? profileImage;
  String? uid;
  DateTime? timestamp;
  LikeModel({
    this.like,
    this.likeID,
    this.postID,
    this.uname,
    this.email,
    this.profileImage,
    this.uid,
    this.timestamp,
  });

  LikeModel copyWith({
    String? like,
    String? likeID,
    String? postID,
    String? uname,
    String? email,
    String? profileImage,
    String? uid,
    DateTime? timestamp,
  }) {
    return LikeModel(
      like: like ?? this.like,
      likeID: likeID ?? this.likeID,
      postID: postID ?? this.postID,
      uname: uname ?? this.uname,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      uid: uid ?? this.uid,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'like': like,
      'likeID': likeID,
      'postID': postID,
      'uname': uname,
      'email': email,
      'profileImage': profileImage,
      'uid': uid,
      'timestamp': timestamp?.millisecondsSinceEpoch,
    };
  }

  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      like: map['like'] != null ? map['like'] as String : null,
      likeID: map['likeID'] != null ? map['likeID'] as String : null,
      postID: map['postID'] != null ? map['postID'] as String : null,
      uname: map['uname'] != null ? map['uname'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LikeModel.fromJson(String source) =>
      LikeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LikeModel(like: $like, likeID: $likeID, postID: $postID, uname: $uname, email: $email, profileImage: $profileImage, uid: $uid, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant LikeModel other) {
    if (identical(this, other)) return true;

    return other.like == like &&
        other.likeID == likeID &&
        other.postID == postID &&
        other.uname == uname &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.uid == uid &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return like.hashCode ^
        likeID.hashCode ^
        postID.hashCode ^
        uname.hashCode ^
        email.hashCode ^
        profileImage.hashCode ^
        uid.hashCode ^
        timestamp.hashCode;
  }
}
