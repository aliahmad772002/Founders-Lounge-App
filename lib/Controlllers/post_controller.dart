import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/Models/postmodel.dart';
import 'package:fouders_longe/Models/usermodel.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PostController extends GetxController {
  static PostController get instance => Get.find();
  final controller = Get.put(FirebaseController());
  TextEditingController captionController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> postTask({
    required File image,
  }) async {
    try {
      String id = const Uuid().v4();

      Reference storageReference =
          FirebaseStorage.instance.ref().child('post_images/$id.png');

      UploadTask uploadTask = storageReference.putFile(image);

      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();

        UserModel user = await FirebaseController.instance.getUserInfo();

        PostModel model = PostModel(
          content: captionController.text,
          postImage: imageUrl,
          postID: id,
          uname: user.uname,
          profession: user.profession,
          profileImage: user.profileImage,
          uid: user.uid,
              timestamp: FieldValue.serverTimestamp(),
          likedBy: [],
        );

        await FirebaseFirestore.instance
            .collection('Post')
            .doc(id)
            .set(model.toMap());

        /// add the id of the post to the user's post list
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'posts': FieldValue.arrayUnion([id]),
        });

        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Posted Successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        captionController.clear();
        // clear the image variable


      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updatePost({
    required String postID,
    required File image,
  }) async {
    try {
      UserModel user = await FirebaseController.instance.getUserInfo();

      DocumentSnapshot postSnapshot =
          await FirebaseFirestore.instance.collection('Post').doc(postID).get();
      String postOwnerUID = postSnapshot.get('uid');

      if (user.uid == postOwnerUID) {
        Reference storageReference =
            FirebaseStorage.instance.ref().child('post_images/$postID.png');

        UploadTask uploadTask = storageReference.putFile(image);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('Post')
              .doc(postID)
              .update({
            'content': captionController.text,
            'postImage': imageUrl,
          });

          ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(
              content: Text('Image Updated'),
              duration: Duration(seconds: 2),
            ),
          );

          captionController.clear();
        });
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('You do not have permission to update this post.'),
            duration: Duration(seconds: 2),
          ),
        );
        print('Error: You do not have permission to update this post.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postID) async {
    try {
      UserModel user = await FirebaseController.instance.getUserInfo();

      DocumentSnapshot postSnapshot =
          await FirebaseFirestore.instance.collection('Post').doc(postID).get();
      String postOwnerUID = postSnapshot.get('uid');

      if (user.uid == postOwnerUID) {
        await FirebaseFirestore.instance
            .collection('Post')
            .doc(postID)
            .delete();
        await FirebaseStorage.instance
            .ref()
            .child('post_images/$postID.png')
            .delete();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'posts': FieldValue.arrayRemove([postID]),
        });

        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Image Deleted'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Error: You do not have permission to delete this post.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// Function to handle liking/disliking a post
  Future<void> handleLikeDislike(String postId) async {
    try {
      // Retrieve the current user's UID
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      // Get a reference to the book document
      DocumentReference postRef =
          firebaseFirestore.collection('Post').doc(postId);
      DocumentSnapshot bookSnapshot = await postRef.get();
      List<dynamic> likedBy = bookSnapshot.get('likedBy');
      bool isAlreadyLiked = likedBy.contains(currentUserId);
      if (isAlreadyLiked) {
        // User is disliking the book
        likedBy.remove(currentUserId);
      } else {
        // User is liking the book
        likedBy.add(currentUserId);
      }
      // Update the book document with the new like count and likedBy list
      await postRef.update({
        'likedBy': likedBy,
      });
      // Notify listeners of changes
      update();
    } catch (e) {
      log('Error updating likes: $e');
      // Handle errors or display a message to the user
    }
  }
}
