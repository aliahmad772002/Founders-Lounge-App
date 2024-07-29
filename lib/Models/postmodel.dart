import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? content;
  String? postImage;
  String? postID;
  String? uname;
  String? profession;
  String? profileImage;
  String? uid;
  FieldValue? timestamp;
  List? likedBy;

  // Constructor
  PostModel({
    this.content,
    this.postImage,
    this.postID,
    this.uname,
    this.profession,
    this.profileImage,
    this.uid,
    this.timestamp,
    this.likedBy,
  });

  // Factory method to create a PostModel from a map
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      content: map['content'],
      postImage: map['postImage'],
      postID: map['postID'],
      uname: map['uname'],
      profession: map['profession'],
      profileImage: map['profileImage'],
      uid: map['uid'],
      timestamp: map['timestamp'],
      likedBy: map['likedBy'],
    );
  }

  // Method to convert PostModel to a map
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'postImage': postImage,
      'postID': postID,
      'uname': uname,
      'profession': profession,
      'profileImage': profileImage,
      'uid': uid,
      'timestamp': timestamp,
      'likedBy': likedBy,
    };
  }
}
