import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/constants/colors.dart';
import 'package:get/get.dart';

import '../../../Controlllers/firebase_controller.dart';

class PostDetails extends StatefulWidget {
  final String postID;
  final String uid;
  final String uname;
  final String profileImage;
  final String postImage;
  final String content;
  final List likes;
  // final List? comments;
  final String profession;
  const PostDetails({
    required this.postID,
    required this.uid,
    required this.uname,
    required this.profileImage,
    required this.postImage,
    required this.content,
    required this.likes,
    // required this.comments,
    required this.profession,
    super.key,
  });

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final controller = Get.put(FirebaseController());

  //
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Post Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            // Displaying post details
            Container(
              width: width,
              height: height,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.profileImage,
                        ),
                      ),
                    ),
                    title: Text(
                      widget.uname,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.profession,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(widget.content,
                        style: const TextStyle(
                          fontSize: 14,
                        )),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(widget.postImage),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 50,
                          // height: 50,
                          margin: const EdgeInsets.only(
                            right: 10,
                            left: 20,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 25,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.likes.length.toString(),
                                style: const TextStyle(
                                    color: color3, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.comment_rounded,
                            color: color3,
                          ),
                          label: const Text(
                            'Comment',
                            style: TextStyle(color: color3, fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color1,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.send_rounded, color: Colors.blue),
                          label: const Text('Share', style: TextStyle(color: Colors.blue)),
                          onPressed: () async {
                            await controller.sharePost(
                              widget.postImage,
                              widget.content,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // to show all the comment this post have
                  Expanded(
                    child: // to show all the comment this post have
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Post')
                          .doc(widget.postID)
                          .collection('comments')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No comments available.'));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(), // Add this line
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: snapshot.data!.docs.isNotEmpty
                                      ? Image.network(
                                          snapshot.data!.docs[index]
                                              .get('profileImage'),
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator()),
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
                                snapshot.data!.docs[index].get('comment'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
