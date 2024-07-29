import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/Models/usermodel.dart';
import 'package:fouders_longe/modules/Bottom%20Navigation%20Bar%20Screen/Chats%20Screen/single_chat_screen.dart';
import 'package:get/get.dart';


class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  TextEditingController searchController = TextEditingController();
  final controller = Get.put(FirebaseController());
  late FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  Future<List<UserModel>> getChatUsers() async {
    try {
      // Replace 'users' with the actual collection name in your Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();

      List<UserModel> users = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();

      // Filter out the current user from the list
      String currentUserId = controller.auth.currentUser?.uid ?? '';
      users.removeWhere((user) => user.uid == currentUserId);

      return users;
    } catch (e) {
      print('Error fetching chat users: $e');
      return [];
    }
  }

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
    return GestureDetector(
      onTap: () {
        if (searchFocusNode.hasFocus) {
          searchFocusNode.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CustomTextField(
                //   controller: searchController,
                //   padding: const EdgeInsets.only(top: 20, left: 10),
                //   focusedIconTextSize: 18,
                //   fontWeight: FontWeight.w400,
                //   txt: "Search",
                //   hidePassword: false,
                //   keyboardType: TextInputType.name,
                //   unFocusedIcon: const Icon(CupertinoIcons.search),
                //   focusedIconText: "🔍",
                //   focusedIcon: const Icon(CupertinoIcons.search),
                //   focusNode: searchFocusNode,
                // ),
                const Padding(
                  padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  child: Text(
                    "Messages",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder<List<UserModel>>(
                  future: getChatUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No chat users found.'),
                      );
                    } else {
                      List<UserModel> chatUsers = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: chatUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                chatUsers[index].profileImage ?? '',
                              ),
                            ),
                            title: Text(chatUsers[index].uname ?? '', style: const TextStyle(color: Colors.black, fontSize: 18),),
                            subtitle: Text(chatUsers[index].profession ?? '', style: const TextStyle(color: Colors.black, fontSize: 14),),
                            onTap: () {
                              String currentUserId =
                                  controller.auth.currentUser?.uid ?? '';
                              String chatID = chatroomid(
                                currentUserId,
                                chatUsers[index].uid ?? '',
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    tokenID: chatUsers[index].tokenID ?? '',
                                    receiverName: chatUsers[index].uname ?? '',
                                    receiverID: chatUsers[index].uid ?? '',
                                    chatID: chatID,
                                    receiverProfileImage:
                                    chatUsers[index].profileImage ?? '',
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {},
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
