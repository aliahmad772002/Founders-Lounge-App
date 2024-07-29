import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? comment;
  String? commentID;
  String? postID;
  String? uname;
  String? email;
  String? profileImage;
  String? uid;
  DateTime? timestamp;

  CommentModel({
    this.comment,
    this.commentID,
    this.postID,
    this.uname,
    this.email,
    this.profileImage,
    this.uid,
    this.timestamp,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      comment: map['comment'] as String?,
      commentID: map['commentID'] as String?,
      postID: map['postID'] as String?,
      uname: map['uname'] as String?,
      email: map['email'] as String?,
      profileImage: map['profileImage'] as String?,
      uid: map['uid'] as String?,
      timestamp: (map['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'commentID': commentID,
      'postID': postID,
      'uname': uname,
      'email': email,
      'profileImage': profileImage,
      'uid': uid,
      'timestamp': timestamp,
    };
  }
}
