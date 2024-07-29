import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fouders_longe/Models/usermodel.dart';
import 'package:fouders_longe/modules/Bottom%20Navigation%20Bar%20Screen/bottom_navbar.dart';
import 'package:fouders_longe/modules/Login%20Screen/login_in.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



class FirebaseController extends GetxController {
  static FirebaseController get instance => Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController profesionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnfController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? errorMessage;
  String? status;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging firebasemessaging = FirebaseMessaging.instance;
  void getToken() {
    firebasemessaging.getToken().then((value) {
      StaticData.tokenId = value!;
      print('token id ${StaticData.tokenId} ');
    });
  }

  Future signUp(
  {required File? image,}
      ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (userCredential.user != null) {
        getToken();

        print('uid of the current user ----> ${userCredential.user!.uid}');

        postdatatoDB(
            id: userCredential.user!.uid,
          image: image,
        );
        Get.offAll(const LoginIn());
        showSnackBar(
          'Success',
          'Now please login!',
          Icons.check,
          Colors.green,
        );

      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        'Error',
        e.message!,
        Icons.close,
        Colors.red,
      );
    }

    /// Stores user data on firebase
  }

  void postdatatoDB({
    required String id,
    File? image,
  }) async {
    // Check if an image is selected
    if (image != null) {
      // Upload image to Firebase Storage
      Reference storageReference =
      FirebaseStorage.instance.ref().child('profile_images/$id.png');

      UploadTask uploadTask = storageReference.putFile(image);

      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();

        // Save user data with image URL to Firestore
        UserModel model = UserModel(
          uname: nameController.text,
          profession: profesionController.text,
          phone: phoneController.text,
          email: emailController.text,
          password: passwordController.text,
          cnfpwd: cnfController.text,
          tokenID: StaticData.tokenId,
          uid: id,
          profileImage: imageUrl,
          followers: [],
          following: [],
          posts: [],

        );
        // Add new user to 'users' collection
        await firebaseFirestore.collection('users').doc(id).set(model.toMap());
      });
    } else {
      // If no image is selected, save user data without an image URL
      UserModel model = UserModel(
        uname: nameController.text,
        profession: profesionController.text,
        phone: phoneController.text,
        email: emailController.text,
        password: passwordController.text,
        cnfpwd: cnfController.text,
        tokenID: StaticData.tokenId,
        uid: id,
        followers: [],
        following: [],
        posts: [],
      );

      // Use set with merge: true to update existing fields and add new ones if the document exists.
      await firebaseFirestore.collection('users').doc(id).set(
        model.toMap(),
        SetOptions(merge: true),
      );

      // Continue with the rest of your code...
    }
  }

  Future<UserModel> getUserInfo() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc =
      await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Explicitly cast the data to Map<String, dynamic>
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return UserModel.fromMap(userData);
      } else {
        // Handle the case where user information is not found
        return const UserModel(); // You might want to handle this better
      }
    } catch (e) {
      // Handle exceptions
      print(e.toString());
      return const UserModel(); // You might want to handle this better
    }
  }


  Future<void> deleteAccount()async {
    // Delete user's account data from firestore and firebase auth, and delete user's posts from firestore, and delete user's comments from firestore, and delete user's likes from firestore, and delete user's followers from firestore, and delete user's following from firestore, and delete user's chats from firestore, and delete user's messages from firestore, and delete user's notifications from firestore, and delete user's saved posts from firestore, and delete user's saved comments from firestore, and delete user's saved replies from firestore, and delete user's saved messages from firestore, and delete user's saved notifications from firestore, and delete user's saved chats from firestore, and delete user's saved followers from firestore, and delete user's saved following from firestore, and delete user's saved likes from firestore, and delete user's saved dislikes from firestore, and delete user's saved posts from firestore, and profile image from firebase storage
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        try {
          String uid = currentUser.uid;
          // Delete user's posts from firestore
          QuerySnapshot postsSnapshot = await firebaseFirestore
              .collection('posts')
              .where('uid', isEqualTo: uid)
              .get();

          postsSnapshot.docs.forEach((postDoc) async {
            // Delete user's comments from firestore
            QuerySnapshot commentsSnapshot = await firebaseFirestore
                .collection('posts')
                .doc(postDoc.id)
                .collection('comments')
                .where('uid', isEqualTo: uid)
                .get();

              // Delete user's comments from firestore
              commentsSnapshot.docs.forEach((commentDoc) async {
                await firebaseFirestore
                    .collection('posts')
                    .doc(postDoc.id)
                    .collection('comments')
                    .doc(commentDoc.id)
                    .delete();
              });

            // Delete user's likes from firestore
            QuerySnapshot likesSnapshot = await firebaseFirestore
                .collection('posts')
                .doc(postDoc.id)
                .collection('likedBy')
                .where('uid', isEqualTo: uid)
                .get();

            likesSnapshot.docs.forEach((likeDoc) async {
              // Delete user's likes from firestore
              await firebaseFirestore
                  .collection('posts')
                  .doc(postDoc.id)
                  .collection('likes')
                  .doc(likeDoc.id)
                  .delete();
            });

            // Delete user's dislikes from firestore
            QuerySnapshot dislikesSnapshot = await firebaseFirestore
                .collection('posts')
                .doc(postDoc.id)
                .collection('dislikes')
                .where('uid', isEqualTo: uid)
                .get();

            dislikesSnapshot.docs.forEach((dislikeDoc) async {
              // Delete user's dislikes from firestore
              await firebaseFirestore
                  .
              collection('posts')
                  .doc(postDoc.id)
                  .collection('dislikes')
                  .doc(dislikeDoc.id)
                  .delete();
            });

            // Delete user's posts from firestore
            await firebaseFirestore.collection('posts')
                .doc(postDoc.id)
                .delete();
          });
        } catch (e) {
          print('Error: $e');
        }
      }
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to delete account: $e',
        Icons.close,
        Colors.red,
      );
    }
  }

  Future<void> updateUserData({required File? image}) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        // Check if a password change is needed
        if (passwordController.text.isNotEmpty) {
          await currentUser.updatePassword(passwordController.text);
        }
        // Check if an image is selected
        if (image != null) {
          // Upload image to Firebase Storage
          Reference storageReference = FirebaseStorage.instance.ref().child('profile_images/$uid.png');

          UploadTask uploadTask = storageReference.putFile(image);

          await uploadTask.whenComplete(() async {
            String imageUrl = await storageReference.getDownloadURL();

            await firebaseFirestore
                .collection('users')
                .doc(uid)
                .update(
              {
                'uname': nameController.text,
                'profession': profesionController.text,
                'phone': phoneController.text,
                'profileImage': imageUrl,
                // 'password': updatedModel.password,
                // 'cnfpwd': updatedModel.cnfpwd,
              }
            );
          });
        }
        else {
          // Use update with merge: true to update existing fields and add new ones if the document exists.
          await firebaseFirestore
              .collection('users')
              .doc(uid)
              .update(
            {
              'uname': nameController.text,
              'profession': profesionController.text,
              'phone': phoneController.text,
              // 'password': updatedModel.password,
              // 'cnfpwd': updatedModel.cnfpwd,
            }
          );
        }
        Navigator.pop(Get.context!);
        showSnackBar(
          'Success',
          'User data updated!',
          Icons.check,
          Colors.green,
        );
      }
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to update user data: $e',
        Icons.close,
        Colors.red,
      );
    }
  }

  // login/////////
  String? _userEmail;
  void signin() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      User user = (await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user!;
        StaticData.uid = user.uid;
        print('uid of the current user ----> ${StaticData.uid}');
        _userEmail = user.email!;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        print('email of the current user ----> $_userEmail');
        Get.offAll(const BottomNavBarScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(
          'Error',
          'No user found for that email.',
          Icons.close,
          Colors.red,
        );
      } else if (e.code == 'wrong-password') {
        showSnackBar(
          'Error',
          'Wrong password provided for that user.',
          Icons.close,
          Colors.red,
        );
      }
      showSnackBar(
        'Error',
        errorMessage!,
        Icons.close,
        Colors.red,
      );
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.offAll(() => const LoginIn());
  }

  postDataToSP() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('uid', StaticData.uid);
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showSnackBar(String title, String message, IconData icon, Color iconColor) {
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: iconColor),
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.black,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
    );
  }


  Future<void> handleFollowUnfollow({required uid}) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Fetch current user and the user to follow/unfollow

      // Get user data

      // References to current user and the user to follow/unfollow
      DocumentReference currentUserDocRef =
      firebaseFirestore.collection('users').doc(currentUserId);
      DocumentReference userDocRef =
      firebaseFirestore.collection('users').doc(uid);

      // Fetch followers and following lists
      DocumentSnapshot userSnapshot = await userDocRef.get();
      List<dynamic> followers = userSnapshot.get('followers') ?? [];
      List<dynamic> following = userSnapshot.get('following') ?? [];

      bool isFollowed = followers.contains(currentUserId);

      // Toggle follow/unfollow status
      if (isFollowed) {
        // Unfollow the user
        followers.remove(currentUserId);
        following.remove(uid);
      } else {
        // Follow the user
        followers.add(currentUserId);
        following.add(uid);
      }

      // Update the follow/following lists for both users
      await currentUserDocRef.update({
        'following': following,
      });

      await userDocRef.update({
        'followers': followers,
      });

      update(); // Update UI or perform any necessary action
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }
  Future<void> sharePost(String imageUrl, String caption) async {
    try {
      // Download the image to a temporary file
      final ByteData imageData = await NetworkAssetBundle(Uri.parse(imageUrl)).load('');
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/image.png');
      await tempFile.writeAsBytes(imageData.buffer.asUint8List());

      // Share the image with the caption
      await Share.shareFiles(
        [(tempFile.path)],
        text: caption,
        subject: 'Post Caption',
      );
    } catch (e) {
      print('Error sharing post: $e');
    }
  }

}

class StaticData {
  static String uid = '';
  static String tokenId = '';
}