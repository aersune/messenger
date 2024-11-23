import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/model/message.dart';

import '../model/user.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FocusNode messageFocusNode = FocusNode();
  TextEditingController messageController = TextEditingController();



  String editingMessageId = "";
    UserData userData = UserData(email: '',name: '', uid: '');
  var isEditing = false;

  Future<void> getUserData() async {
    final user =  _firebaseAuth.currentUser;
    final userDataDb = await _firebaseFirestore.collection('users').doc(user!.uid).get();
    userData = UserData.fromJson(userDataDb.data()!);

    notifyListeners();
  }

  Future<void> changeName(String newName) async {
    final user = _firebaseAuth.currentUser;
    await _firebaseFirestore.collection('users').doc(user!.uid).update({"name": newName});
    notifyListeners();
  }

  //get user data

  editMessage(String messageId, String message, context) async {
    editingMessageId = messageId;
    messageController.text = message;
    isEditing = true;
    FocusScope.of(context).requestFocus(messageFocusNode);
    notifyListeners();
  }

  //Send message
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create new message
    Message newMessage = Message(
      message: message,
      senderId: currentUserId,
      receiverId: receiverId,
      senderEmail: currentUserEmail,
      timestamp: timestamp,
    );

    // construct chat room id from current user id and receiver id
    List<String> ids = [
      currentUserId,
      receiverId,
    ];
    ids.sort();
    String chatRoomId = ids.join('_');

    //add new message to database
    await _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [
      userId,
      otherUserId,
    ];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  //edit message

  Future<void> deleteMessage({required String messageId, required String otherUserId}) async {
    List<String> ids = [
      _firebaseAuth.currentUser!.uid,
      otherUserId,
    ];
    ids.sort();
    String chatRoomId = ids.join('_');
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete()
        .then((value) {
      print('Message deleted successfully');
    }).catchError((error) {
      print('Error deleting message: $error');
    });

    notifyListeners();
  }

  Future<void> updateMessageReadStatus(String messageId) async {
    await _firebaseFirestore.collection('chat_rooms').doc(messageId).update({
      'isRead': true,
    });

    notifyListeners();
  }

  Future<void> updateMessage({required String messageId, required String newMessage, required otherUserId}) async {
    List<String> ids = [
      _firebaseAuth.currentUser!.uid,
      otherUserId,
    ];
    ids.sort();
    String chatRoomId = ids.join('_');
    await _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages').doc(messageId).update({
      'message': newMessage,
      'isChanged': true,
    });

    print('updated');
    notifyListeners();
  }

}
// get messages
