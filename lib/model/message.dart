import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String senderId;
  final String receiverId;
  final String senderEmail;
  final Timestamp timestamp;
  final bool isRead;
  final bool isChanged;
  final bool isReplied;
  final String? repliedMessage;
  final String? repliedMessageId;
  final String? repliedMessageSenderId;
  final bool isFile;
  final String? filePath;

  Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.senderEmail,
    required this.timestamp,
    this.isChanged = false,
    this.isRead = false,
    required this.isReplied,
    required this.repliedMessage,
    required this.repliedMessageId,
    required this.repliedMessageSenderId,
    this.isFile = false,
    this.filePath = '',
  });

  Map<String, dynamic> toMap() => {
        'message': message,
        'senderId': senderId,
        'receiverId': receiverId,
        'senderEmail': senderEmail,
        'timestamp': timestamp,
        "isRead": isRead,
        "isChanged": isChanged,
        "isReplied": isReplied,
        "repliedMessage": repliedMessage,
        "repliedMessageId": repliedMessageId,
        "repliedMessageSenderId": repliedMessageSenderId,
    "isFile": isFile,
    "filePath": filePath,
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      senderEmail: json['senderEmail'],
      timestamp: json['timestamp'],
      isRead: json['isRead'] ?? false,
      isChanged: json['isChanged'] ?? false,
      isReplied: json['isReplied'] ?? false,
      repliedMessage: json['repliedMessage'],
      repliedMessageId: json['repliedMessageId'],
      repliedMessageSenderId: json['repliedMessageSenderId'],
      isFile: json['isFile'] ?? false,
      filePath: json['filePath'],
    );
  }
}
