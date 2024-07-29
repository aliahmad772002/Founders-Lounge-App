import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/chat_controller.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/Models/usermodel.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  String receiverName;
  String receiverID;
  String chatID;
  String receiverProfileImage;
String? tokenID;

  ChatScreen({
    Key? key,
    required this.receiverName,
    required this.receiverID,
    required this.chatID,
    required this.receiverProfileImage,
    required this.tokenID,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ccontroller = Get.put(ChatController());
  final controller = Get.put(FirebaseController());
  TextEditingController msgController = TextEditingController();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  http.Response? response;

  sendNotifcation(String msg) async {
    UserModel user = await FirebaseController.instance.getUserInfo();
    var body = {
      "registration_ids": [
        //tokan id of receiver
        widget.tokenID

      ],
      "notification": {

        "body": msg,
        "title": '${user.uname}',
        "android_channel_id": "pushnotificationapp",
        "sound": true,
      },
      "data": {
        "source": "chat",
      }
    };


    response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',

          // server key
          'authorization':
          'key=AAAAdCRlElg:APA91bHgV5lBAjPYqmCtQ2LDWpjVpYjmL0gFbmnGp2RtWvn4RGE-oFUM4ILk_t4UHEcI_2WqXjZfysv7_SjT2sVyOBGVETtsAbM5B40FWlVyjomDAYi4lVVOm0SbKXVH0vJ9K5Wp-aTG'
        },
        body: jsonEncode(body));
    if (response!.statusCode == 200) {
      print(response!.body);
    }
  }





  void onSendMessage() async {
    UserModel user = await FirebaseController.instance.getUserInfo();
    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendBy": user.uname!,
        "message": msgController.text,
        "time": DateTime.now(),
        "messageID": const Uuid().v4(),
        'senderID': user.uid,
        'receiverID': widget.receiverID,
        'tokenID': widget.tokenID,
      };

      await firebaseFirestore
          .collection('chatroom')
          .doc(widget.chatID)
          .collection('chats')
          .doc(messages['messageID'])
          .set(messages);

      // Add this block to store the notification in Firestore
      Map<String, dynamic> notification = {
        'message': msgController.text,
        'senderProfileImage': user.profileImage,
        'senderID': user.uid,
        'senderName': user.uname,
        'receiverID': widget.receiverID,
        'time': DateTime.now(),
      };
      await firebaseFirestore
          .collection('notifications')
          .doc()
          .set(notification);

      sendNotifcation(msgController.text);

      msgController.clear();
    } else {
      print("Enter Some Text");
    }
  }

  void onSendMediaMessage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      // Upload the file to Firebase Storage
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';
      Reference ref = FirebaseStorage.instance.ref().child('chat_media').child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded file
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Send a message with the download URL as the content
      UserModel user = await FirebaseController.instance.getUserInfo();
      Map<String, dynamic> messages = {
        "sendBy": user.uname!,
        "message": downloadUrl,
        "time": DateTime.now(),
        "messageID": const Uuid().v4(),
        'senderID': user.uid,
        'receiverID': widget.receiverID,
        'tokenID': widget.tokenID,
        'isMedia': true,  // Add this field to indicate that the message is a media message
      };
      await firebaseFirestore
          .collection('chatroom')
          .doc(widget.chatID)
          .collection('chats')
          .doc(messages['messageID'])
          .set(messages);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.receiverProfileImage),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.receiverName,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chatroom')
                      .doc(widget.chatID)
                      .collection('chats')
                      .orderBy("time", descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data?.docs[index].data()
                              as Map<String, dynamic>;
                          return messages(MediaQuery.of(context).size, data);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        onSendMediaMessage();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: msgController,
                        decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          onSendMessage();
                        },
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> data) {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    bool isCurrentUser = data['senderID'] == currentUserID;

    return Container(
      width: size.width,
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              size.width * 0.7, // Set a maximum width for the message container
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isCurrentUser ? Colors.blue : Colors.red[100],
        ),
        child: PopupMenuButton<String>(
          itemBuilder: (context) {
            List<PopupMenuEntry<String>> items = [];

            if (isCurrentUser) {
              items.add(
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
              );

              items.add(
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              );
            }

            return items;
          },
          onSelected: (value) async {
            if (value == 'edit') {
              // Get the new message content from the user
              String newContent = await showDialog(
                context: context,
                builder: (context) {
                  final controller =
                      TextEditingController(text: data['message']);
                  return AlertDialog(
                    title: Text('Edit message'),
                    content: TextField(
                      controller: controller,
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('Save'),
                        onPressed: () => Navigator.of(context).pop(
                            controller.text.isNotEmpty
                                ? controller.text
                                : data['message']),
                      ),
                    ],
                  );
                },
              );

              // Update the message
              ccontroller.updateMessage(
                  widget.chatID, data['messageID'], newContent);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message updated successfully')),
              );
                        } else if (value == 'delete') {
              // Delete the message
              ccontroller.deleteMessage(widget.chatID, data['messageID']);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message deleted successfully')),
              );
            }
          },
          child: Text(
            data['message'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isCurrentUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
