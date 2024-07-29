import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/modules/Bottom%20Navigation%20Bar%20Screen/Profile%20Screen/post_detail.dart';
import 'package:fouders_longe/modules/SignUp%20Screen/update_profile.dart';
import 'package:get/get.dart';

import '../../Login Screen/login_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.put(FirebaseController());
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F5),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
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
                          stream: controller.firebaseFirestore
                              .collection('users')
                              .doc(controller.auth.currentUser!.uid)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot<Object?>>
                              snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {

                              return const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.pink),
                                    ),
                                    SizedBox(height: 10),
                                    Text('Loading...',
                                        style: TextStyle(color: Colors.pink)),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          child: snapshot.data != null
                                              ? Image.network(
                                            snapshot.data!
                                                .get('profileImage'),
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )
                                              : const Center(
                                              child:
                                              CircularProgressIndicator()),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!['uname'],
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            snapshot.data!['profession'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      PopupMenuButton<String>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        surfaceTintColor: Colors.grey[300],
                                        itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                          PopupMenuItem<String>(
                                            value: 'edit',
                                            child: const ListTile(
                                              leading: Icon(Icons.edit),
                                              title: Text('Edit Profile'),
                                            ),
                                            onTap: () {

                                              Get.to(UpdateProfileScreen(
                                                profileImage: snapshot.data!
                                                    .get('profileImage'),
                                                name: snapshot.data!
                                                    .get('uname'),
                                                profession: snapshot.data!
                                                    .get('profession'),
                                                phone: snapshot.data!
                                                    .get('phone'),
                                              ));
                                            },
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'logout',
                                            child: const ListTile(
                                              leading: Icon(Icons.logout),
                                              title: Text('Logout'),
                                            ),
                                            onTap: () {
                                              controller.logout();
                                            },
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: const ListTile(
                                              leading: Icon(Icons.delete),
                                              title: Text('Delete Account'),
                                            ),
                                            onTap: () {
                                              // Delete user's account data from firestore and firebase auth, and delete user's posts from firestore, and delete user's comments from firestore, and delete user's likes from firestore, and delete user's followers from firestore, and delete user's following from firestore, and delete user's chats from firestore, and delete user's messages from firestore, and delete user's notifications from firestore, and delete user's saved posts from firestore, and delete user's saved comments from firestore, and delete user's saved replies from firestore, and delete user's saved messages from firestore, and delete user's saved notifications from firestore, and delete user's saved chats from firestore, and delete user's saved followers from firestore, and delete user's saved following from firestore, and delete user's saved likes from firestore, and delete user's saved dislikes from firestore, and delete user's saved posts from firestore, and profile image from firebase storage
                                              FirebaseAuth.instance.currentUser!
                                                  .delete()
                                                  .then((value) {
                                                controller.firebaseFirestore
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance
                                                    .currentUser!.uid)
                                                    .delete();
                                              });
                                              FirebaseFirestore.instance
                                                  .collection('Post')
                                                  .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                                  .get()
                                                  .then((snapshot) {
                                                for (DocumentSnapshot ds
                                                in snapshot.docs) {
                                                  ds.reference.delete();
                                                }
                                              });
                                              Get.offAll(() => const LoginIn());
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
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
                                            /// Number of posts current user have posted
                                            Text(
                                              // '123',
                                              snapshot.data!['posts'].length
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
                                              "Posts",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const VerticalDivider(
                                          thickness: 1,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            /// Number of Followers current user have
                                            Text(
                                              snapshot.data!['followers'].length
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
                                              "Followers",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const VerticalDivider(
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
                                            /// Number of people current user is following
                                            Text(
                                              snapshot.data!['following'].length
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
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
                            } else {
                              return const Center(
                                child: Text('No Data Found'),
                              );
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),

            /// Posts Section
            Container(
              width: width,
              height: height * 0.5,
              margin: const EdgeInsets.all(10),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Post')
                    .where('uid',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
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


                             Get.to(() => PostDetails(
                                postID: snapshot.data!.docs[index].id,
                                uid: snapshot.data!.docs[index].get('uid'),
                                uname: snapshot.data!.docs[index].get('uname'),
                                profileImage: snapshot.data!.docs[index].get('profileImage'),
                                postImage: snapshot.data!.docs[index].get('postImage'),
                               content: snapshot.data!.docs[index].get('content'),
                                likes: snapshot.data!.docs[index].get('likedBy'),
                                // comments: snapshot.data!.docs[index].get('comments'),
                               profession: snapshot.data!.docs[index].get('profession'),
                              )
                             );


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


          ],
        ),
      ),
    );
  }
}

// class NetworkImageWithOrientation extends StatefulWidget {
//   final String url;
//
//   const NetworkImageWithOrientation({super.key, required this.url});
//
//   @override
//   NetworkImageWithOrientationState createState() =>
//       NetworkImageWithOrientationState();
// }
//
// class NetworkImageWithOrientationState
//     extends State<NetworkImageWithOrientation> {
//   late Future<ui.Image> _futureImage;
//
//   @override
//   void initState() {
//     super.initState();
//     _futureImage = _getImage();
//   }
//
//   Future<ui.Image> _getImage() {
//     ImageStream stream =
//     Image.network(widget.url).image.resolve(ImageConfiguration.empty);
//     Completer<ui.Image> completer = Completer<ui.Image>();
//     void listener(ImageInfo info, bool _) {
//       if (!completer.isCompleted) {
//         completer.complete(info.image);
//       }
//     }
//
//     stream.addListener(ImageStreamListener(listener));
//     completer.future
//         .then((_) => stream.removeListener(ImageStreamListener(listener)));
//     return completer.future;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ui.Image>(
//       future: _futureImage,
//       builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasData) {
//             return AspectRatio(
//               aspectRatio: snapshot.data!.width / snapshot.data!.height,
//               child: Image.network(widget.url, fit: BoxFit.cover),
//             );
//           } else {
//             return Text('Error: ${snapshot.error}');
//           }
//         } else {
//           return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }
