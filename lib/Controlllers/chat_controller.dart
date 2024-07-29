import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  TextEditingController msgController = TextEditingController();


  Future<void> updateMessage(String chatId, String messageId, String newContent) async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatId)
        .collection('chats')
        .doc(messageId)
        .update({'message': newContent});
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatId)
        .collection('chats')
        .doc(messageId)
        .delete();
  }
}








// class ChatController extends GetxController {
//   static ChatController get instance => Get.find();
//   TextEditingController msgController = TextEditingController();
//   String? currentUserID;

//   Future<void> sendMessage(String receiverUserID, String receiverName) async {
//     try {
//       UserModel user = await FirebaseController.instance.getUserInfo();
//       currentUserID = user.uid;

//       String chatID = Uuid().v4();

//       ChatModel newMessage = ChatModel(
//         chatID: chatID,
//         message: msgController.text,
//         senderName: user.uname!,
//         senderID: user.uid,
//         timestamp: DateTime.now(),
//       );

//       // Send message to the receiver's chat as well
//       await FirebaseFirestore.instance
//           .collection('Chats')
//           .doc(receiverUserID)
//           .collection('messages')
//           .add(newMessage.toMap());

//       await FirebaseFirestore.instance
//           .collection('Chats')
//           .doc(currentUserID)
//           .collection('messages')
//           .add(newMessage.toMap());

//       msgController.clear();
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }
// }
