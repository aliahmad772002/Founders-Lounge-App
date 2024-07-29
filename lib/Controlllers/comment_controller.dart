import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/Models/coment_model.dart';
import 'package:fouders_longe/Models/usermodel.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CommentController extends GetxController {
  static CommentController get instance => Get.find();

  final TextEditingController commentController = TextEditingController();

  Future<void> postComment(String postID) async {
    try {
      UserModel user = await FirebaseController.instance.getUserInfo();

      CommentModel commentModel = CommentModel(
        comment: commentController.text,
        commentID: const Uuid().v4(),
        postID: postID,
        uname: user.uname,
        email: user.email,
        profileImage: user.profileImage,
        uid: user.uid,
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('Post')
          .doc(postID)
          .collection('comments')
          .add(commentModel.toMap());

      // Clear the comment text field after posting
      commentController.clear();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateComment(
      String commentID, String newComment, String postID) async {
    try {
      var commentDoc = await FirebaseFirestore.instance
          .collection('Post')
          .doc(postID)
          .collection('comments')
          .doc(commentID)
          .get();

      if (commentDoc.exists) {
        await commentDoc.reference.update({'comment': newComment});
      } else {
        // Handle the case where the document does not exist
        log('Document not found for update: $commentID at path ${commentDoc.reference.path}');
      }
    } catch (e, stackTrace) {
      log('Error updating comment: $e\n$stackTrace');
    }
  }

  Future<void> deleteComment(String commentID, String postID) async {
    try {
      var commentDoc = await FirebaseFirestore.instance
          .collection('Post')
          .doc(postID)
          .collection('comments')
          .doc(commentID)
          .get();

      if (commentDoc.exists) {
        await commentDoc.reference.delete();
      } else {
        // Handle the case where the document does not exist
        log('Document not found for delete: $commentID at path ${commentDoc.reference.path}');
      }
    } catch (e, stackTrace) {
      log('Error deleting comment: $e\n$stackTrace');
    }
  }
}
