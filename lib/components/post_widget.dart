import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/post_controller.dart';
import 'package:fouders_longe/components/comments.dart';
import 'package:fouders_longe/constants/colors.dart';
import 'package:fouders_longe/modules/Bottom%20Navigation%20Bar%20Screen/Add%20New%20Posts/edit_post.dart';
import 'package:get/get.dart';

class PostWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> post;
  final bool isCurrentUserOwner;

  const PostWidget({
    Key? key,
    required this.post,
    required this.isCurrentUserOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void commentSheet(String postID) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CommentSheet(postID: postID);
        },
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        color: color1,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      post.get('profileImage'),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  post.get('uname'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  post.get('profession'),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  surfaceTintColor: Colors.grey[300],
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    if (isCurrentUserOwner) // Show "Edit" and "Delete" only if the current user is the owner
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        ),
                        onTap: () {
                          String postID = post.id;
                          if (postID.isNotEmpty) {
                            Get.to(EditPost(postID: postID, postImage: post.get('postImage')));
                          } else {
                            print('Error: Unable to get post ID');
                          }
                        },
                      ),
                    if (isCurrentUserOwner)
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                        ),
                        onTap: () {
                          // Call deletePost method when "Delete" is selected
                          PostController.instance.deletePost(post.id);
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(post.get('content')),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(post.get('postImage')),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Add like functionality
                  },
                  icon: const Icon(
                    Icons.favorite_border_rounded,
                    color: color4,
                  ),
                  label: const Text(
                    '24',
                    style: TextStyle(color: color4, fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    commentSheet(post.id);
                  },
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
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.blue),
                  onPressed: () {
                    // Add send functionality
                  },
                ),
                const Spacer(),
                IconButton(
                  icon:
                      const Icon(Icons.bookmark_border_rounded, color: color3),
                  onPressed: () {
                    // Add bookmark functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
