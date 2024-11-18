import 'package:cloud_firestore/cloud_firestore.dart';



class Message {
  final String message;
  final String senderId;
  final String receiverId;
  final String senderEmail;
  final Timestamp timestamp;


  Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.senderEmail,
    required this.timestamp,
  });


  Map<String, dynamic> toMap() => {
    'message': message,
    'senderId': senderId,
    'receiverId': receiverId,
    'senderEmail': senderEmail,
    'timestamp': timestamp,
  };

}