import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/Controlllers/post_controller.dart';
import 'package:fouders_longe/components/comments.dart';
import 'package:fouders_longe/constants/colors.dart';
import 'package:fouders_longe/modules/Bottom%20Navigation%20Bar%20Screen/Add%20New%20Posts/edit_post.dart';
import 'package:fouders_longe/modules/Bottom%20Navigation%20Bar%20Screen/Profile%20Screen/alternative_profile.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pcontroller = Get.put(PostController());
  final controller = Get.put(FirebaseController());


  int likeCount = 0;
  Color isLiked = Colors.black;

  void commentSheet(String postID) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommentSheet(postID: postID);
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Discover',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            // Displaying demo posts
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Post')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {

                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.pink),
                            ),
                            SizedBox(height: 10),
                            Text('Loading...',
                                style: TextStyle(color: Colors.pink)),
                          ],
                        ),
                      );
                    }
                    else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      // Display a message when there are no comments
                      return const Center(
                        child: Text('No Posts available.'),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          String postOwnerUID =
                              snapshot.data!.docs[index].get('uid');
                          bool isCurrentUserOwner = postOwnerUID ==
                              FirebaseController.instance.auth.currentUser?.uid;
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              color: color1,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      child: snapshot.data!.docs.isNotEmpty
                                          ? Image.network(
                                              snapshot.data!.docs[index]
                                                  .get('profileImage'),
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            )
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                    ),
                                  ),
                                  title: Text(
                                    snapshot.data!.docs[index].get('uname'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    snapshot.data!.docs[index]
                                        .get('profession'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    surfaceTintColor: Colors.grey[300],
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      if (isCurrentUserOwner) // Show "Edit" and "Delete" only if the current user is the owner
                                        PopupMenuItem<String>(
                                          value: 'edit',
                                          child: const ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('Edit'),
                                          ),
                                          onTap: () {
                                            String postID = snapshot
                                                .data!.docs[index].id;
                                            if (postID.isNotEmpty) {
                                              Get.to(
                                                  EditPost(postID: postID, postImage: snapshot.data!.docs[index].get('postImage')));
                                            } else {
                                              print(
                                                  'Error: Unable to get post ID');
                                            }
                                          },
                                        ),
                                      if (isCurrentUserOwner)
                                        PopupMenuItem<String>(
                                          value: 'delete',
                                          child: const ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('Delete Post'),
                                          ),
                                          onTap: () {
                                            // Call deletePost method when "Delete" is selected
                                            PostController.instance
                                                .deletePost(snapshot
                                                    .data!.docs[index].id);
                                          },
                                        ),
                                    ],
                                  ),
                                  onTap: () {
                                    String postOwnerUID = snapshot
                                        .data!.docs[index]
                                        .get('uid');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AlternativeProfileScreen(
                                                userID: postOwnerUID),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Text(
                                    snapshot.data!.docs[index]
                                        .get('content'),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // if (posts[index].postImageUrl != null)
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        snapshot.data!.docs[index]
                                            .get('postImage'),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const NeverScrollableScrollPhysics(),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            pcontroller.handleLikeDislike(snapshot.data!.docs[index].id);
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: snapshot.data!.docs[index].get('likedBy').contains(FirebaseController.instance.auth.currentUser?.uid) ? Colors.red : Colors.black,
                                          ),
                                          label: Text(
                                            snapshot.data!.docs[index].get('likedBy').length.toString(),
                                            style: const TextStyle(color: color3, fontSize: 12),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            commentSheet(
                                                snapshot.data!.docs[index].id);
                                          },
                                          icon: const Icon(
                                            Icons.comment_rounded,
                                            color: color3,
                                          ),
                                          label: const Text(
                                            'Comment',
                                            style: TextStyle(
                                                color: color3, fontSize: 12),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: color1,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        TextButton.icon(
                                          icon: const Icon(Icons.send_rounded, color: Colors.blue),
                                          label: const Text('Share', style: TextStyle(color: Colors.blue)),
                                          onPressed: () async {
                                            await controller.sharePost(
                                              snapshot.data!.docs[index].get('postImage'),
                                              snapshot.data!.docs[index].get('content'),
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    else {
                      return const Center(
                        child: Text('No Data Found'),
                      );
                    }
                  }),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
