import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/comment_controller.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/constants/colors.dart';
import 'package:get/get.dart';

class CommentSheet extends StatefulWidget {
  final postID;
  const CommentSheet({super.key, required this.postID});

  @override
  _CommentSheetState createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final controller = Get.put(CommentController());
  final fcontroller = Get.put(FirebaseController());
  late TextEditingController editingController;
  late String editingCommentID;
  @override
  void initState() {
    super.initState();
    editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 50,
                  child: TextField(
                    controller: controller.commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: color2,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    controller.postComment(widget.postID);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color2,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Show the edit button only if the comment is made by the logged-in user
                          if (snapshot.data!.docs[index].get('uid') ==
                              FirebaseAuth.instance.currentUser?.uid)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Call a function to handle the update/edit operation
                                _editComment(snapshot.data!.docs[index].id,
                                    snapshot.data!.docs[index].get('comment'));
                              },
                            ),
                          if (snapshot.data!.docs[index].get('uid') ==
                              FirebaseAuth.instance.currentUser?.uid)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Call a function to handle the delete operation
                                _deleteComment(snapshot.data!.docs[index].id);
                              },
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Inside your _CommentSheetState class...

// Function to handle the update/edit operation
  void _editComment(String commentID, String currentComment) {
    TextEditingController updateController =
        TextEditingController(text: currentComment);

    Get.defaultDialog(
      title: 'Edit Comment',
      content: TextField(controller: updateController),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (updateController.text.trim().isNotEmpty) {
              controller.updateComment(
                  commentID, updateController.text, widget.postID);

              Get.back();
            } else {
              // Show an error message or handle the empty comment case
            }
          },
          child: Text('Update'),
        ),
      ],
    );
  }

// Function to handle the delete operation
  void _deleteComment(String commentID) {
    Get.defaultDialog(
      title: 'Delete Comment',
      middleText: 'Are you sure you want to delete this comment?',
      actions: [
        ElevatedButton(
          onPressed: () {
            controller.deleteComment(commentID, widget.postID);
            Get.back();
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
