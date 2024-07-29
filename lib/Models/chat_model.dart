// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class ChatModel {
//   String? senderName;
//   String? senderID;
//   String? message;
//   String? chatID;
//   String? receiverID;
//   String? recievername;
//   DateTime? timestamp;
//   ChatModel({
//     this.senderName,
//     this.senderID,
//     this.message,
//     this.chatID,
//     this.receiverID,
//     this.recievername,
//     this.timestamp,
//   });

//   ChatModel copyWith({
//     String? senderName,
//     String? senderID,
//     String? message,
//     String? chatID,
//     String? receiverID,
//     String? recievername,
//     DateTime? timestamp,
//   }) {
//     return ChatModel(
//       senderName: senderName ?? this.senderName,
//       senderID: senderID ?? this.senderID,
//       message: message ?? this.message,
//       chatID: chatID ?? this.chatID,
//       receiverID: receiverID ?? this.receiverID,
//       recievername: recievername ?? this.recievername,
//       timestamp: timestamp ?? this.timestamp,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'senderName': senderName,
//       'senderID': senderID,
//       'message': message,
//       'chatID': chatID,
//       'receiverID': receiverID,
//       'recievername': recievername,
//       'timestamp': timestamp?.millisecondsSinceEpoch,
//     };
//   }

//   factory ChatModel.fromMap(Map<String, dynamic> map) {
//     return ChatModel(
//       senderName:
//           map['senderName'] != null ? map['senderName'] as String : null,
//       senderID: map['senderID'] != null ? map['senderID'] as String : null,
//       message: map['message'] != null ? map['message'] as String : null,
//       chatID: map['chatID'] != null ? map['chatID'] as String : null,
//       receiverID:
//           map['receiverID'] != null ? map['receiverID'] as String : null,
//       recievername:
//           map['recievername'] != null ? map['recievername'] as String : null,
//       timestamp: map['timestamp'] != null
//           ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
//           : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ChatModel.fromJson(String source) =>
//       ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'ChatModel(senderName: $senderName, senderID: $senderID, message: $message, chatID: $chatID, receiverID: $receiverID, recievername: $recievername, timestamp: $timestamp)';
//   }

//   @override
//   bool operator ==(covariant ChatModel other) {
//     if (identical(this, other)) return true;

//     return other.senderName == senderName &&
//         other.senderID == senderID &&
//         other.message == message &&
//         other.chatID == chatID &&
//         other.receiverID == receiverID &&
//         other.recievername == recievername &&
//         other.timestamp == timestamp;
//   }

//   @override
//   int get hashCode {
//     return senderName.hashCode ^
//         senderID.hashCode ^
//         message.hashCode ^
//         chatID.hashCode ^
//         receiverID.hashCode ^
//         recievername.hashCode ^
//         timestamp.hashCode;
//   }
// }
