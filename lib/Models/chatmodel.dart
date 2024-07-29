// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chatmodel {
  String? sendBy;
  String? message;
  String? messageID;
  DateTime? timestamp;
  Chatmodel({
    this.sendBy,
    this.message,
    this.messageID,
    this.timestamp,
  });

  Chatmodel copyWith({
    String? sendBy,
    String? message,
    String? messageID,
    DateTime? timestamp,
  }) {
    return Chatmodel(
      sendBy: sendBy ?? this.sendBy,
      message: message ?? this.message,
      messageID: messageID ?? this.messageID,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sendBy': sendBy,
      'message': message,
      'messageID': messageID,
      'timestamp': timestamp?.millisecondsSinceEpoch,
    };
  }

  factory Chatmodel.fromMap(Map<String, dynamic> map) {
    return Chatmodel(
      sendBy: map['sendBy'] != null ? map['sendBy'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      messageID: map['messageID'] != null ? map['messageID'] as String : null,
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chatmodel.fromJson(String source) =>
      Chatmodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chatmodel(sendBy: $sendBy, message: $message, messageID: $messageID, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant Chatmodel other) {
    if (identical(this, other)) return true;

    return other.sendBy == sendBy &&
        other.message == message &&
        other.messageID == messageID &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return sendBy.hashCode ^
        message.hashCode ^
        messageID.hashCode ^
        timestamp.hashCode;
  }
}
