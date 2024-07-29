// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/modules/Bottom%20Navigation%20Bar%20Screen/Chats%20Screen/single_chat_screen.dart';
import 'package:get/get.dart';

import 'alternate_post.dart';

class AlternativeProfileScreen extends StatefulWidget {
  final String userID;

  AlternativeProfileScreen({required this.userID});

  @override
  _AlternativeProfileScreenState createState() =>
      _AlternativeProfileScreenState();
}

class _AlternativeProfileScreenState extends State<AlternativeProfileScreen> {
  final controller = Get.put(FirebaseController());

  String chatroomid(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color(0xFFEFF3F5),
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          height: height,
          width: width,
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: width,
              height: height * 0.28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Container(
                width: width,
                height: height * 0.28,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userID)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return Center(
                              child: Text('User not found.'),
                            );
                          } else {
                            var userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            // is user following the profile of the user whose profile he is viewing
                            bool isFollowingProfile = userData['followers']
                                .contains(controller.auth.currentUser?.uid);
                            print(isFollowingProfile);

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(height: 20),
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: snapshot.data != null
                                            ? Image.network(
                                                userData['profileImage'],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator()),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          userData['uname'],
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          userData['profession'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    PopupMenuButton<String>(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      surfaceTintColor: Colors.grey[300],
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'message',
                                          child: ListTile(
                                            leading: Icon(Icons.message),
                                            title: Text('Send Message'),
                                          ),
                                          onTap: () {
                                            // Assuming you are navigating to ChatScreen from another screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                  receiverID: widget.userID,
                                                  chatID: chatroomid(
                                                      controller.auth
                                                          .currentUser!.uid,
                                                      widget.userID),
                                                  receiverName:
                                                      userData['uname'],
                                                  receiverProfileImage:
                                                      userData['profileImage'],
                                                  tokenID: userData['tokenID'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'request',
                                          child: ListTile(
                                            leading: Icon(Icons.person_add),
                                            title: isFollowingProfile == true
                                                ? Text('Unfollow')
                                                : Text('Follow'),
                                          ),
                                          onTap: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: isFollowingProfile ==
                                                        true
                                                    ? Text(
                                                        'Unfollowed successfully')
                                                    : Text(
                                                        'Followed successfully'),
                                              ),
                                            );
                                            controller.handleFollowUnfollow(
                                              uid: widget.userID,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                    // color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            // '123',
                                            snapshot.data!['posts'].length
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Posts",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        thickness: 0.5,
                                        indent: 10,
                                        endIndent: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data!['followers'].length
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Followers",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        thickness: 0.5,
                                        indent: 10,
                                        endIndent: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data!['following'].length
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Following",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: width,
              height: height * 0.5,
              margin: const EdgeInsets.all(10),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Post')
                    .where('uid', isEqualTo: widget.userID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No posts found.'),
                    );
                  } else {
                    List<String> postImages = snapshot.data!.docs
                        .map((doc) => doc.get('postImage').toString())
                        .toList();

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: postImages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => AlterntePost(
                                  postID: snapshot.data!.docs[index].id,
                                  uid: snapshot.data!.docs[index].get('uid'),
                                  uname:
                                      snapshot.data!.docs[index].get('uname'),
                                  profileImage: snapshot.data!.docs[index]
                                      .get('profileImage'),
                                  postImage: snapshot.data!.docs[index]
                                      .get('postImage'),
                                  content:
                                      snapshot.data!.docs[index].get('content'),
                                  likes:
                                      snapshot.data!.docs[index].get('likedBy'),
                                  // comments: snapshot.data!.docs[index].get('comments'),
                                  profession: snapshot.data!.docs[index]
                                      .get('profession'),
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                postImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ]),
        ));
  }
}
