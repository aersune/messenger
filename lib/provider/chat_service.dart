import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger/model/message.dart';

import '../model/user.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FocusNode messageFocusNode = FocusNode();
  TextEditingController messageController = TextEditingController();

  String editingMessageId = "";
  String editingMessage = "";
  String repliedMessageSenderId = "";
  UserData userData = UserData(email: '', name: '', uid: '', isOnline: false);
  var isEditing = false;
  bool isReplying = false;
  bool whoSender = false;
  bool isScrolling = false;

  @override
  void dispose() {
    messageController.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  void clearMessage() {
    messageController.clear();
    notifyListeners();
  }
   scrollEvent(bool isScroll) {
    isScrolling = isScroll;
    print('provider scrolll: $isScrolling');

    notifyListeners();
  }

  Future<void> getUserData() async {
    final user = _firebaseAuth.currentUser;
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

  setMessage(
    String messageId,
    String message,
  ) {
    editingMessageId = messageId;
    messageController.text = message;
    editingMessage = message;
    messageFocusNode.requestFocus();
    isEditing = true;
    notifyListeners();
  }

  cancelEditing() {
    editingMessageId = "";
    editingMessage = "";
    messageController.clear();
    messageFocusNode.unfocus();
    isEditing = false;
    isReplying = false;
    notifyListeners();
  }

  replayMessage({required String message, required String senderId, required String messageId}) {
    isReplying = true;
    senderId == _firebaseAuth.currentUser!.uid ? whoSender = true : whoSender = false;
    editingMessageId = messageId;
    repliedMessageSenderId = senderId;
    editingMessage = message;
    messageFocusNode.requestFocus();
    notifyListeners();
  }

  //Send message
  Future<void> sendMessage(
      {required String receiverId,
      required String message,
      required bool isReply,
      required String replyUser,
      required String replyMessId,
      required String repliedMessage}) async {
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
      isReplied: isReply,
      repliedMessage: isReply ? repliedMessage : '',
      repliedMessageId: isReply ? replyMessId : '',
      repliedMessageSenderId: isReply ? replyUser : '',
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
    cancelReply();
  }

  cancelReply() {
    isReplying = false;
    editingMessageId = "";
    editingMessage = "";
    notifyListeners();
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
      if (kDebugMode) {
        print('Message deleted successfully');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Error deleting message: $error');
      }
    });

    // notifyListeners();
  }
  Future<void> clearHistory(String otherUserId) async {
    List<String> ids = [
      _firebaseAuth.currentUser!.uid,
      otherUserId,
    ];
    ids.sort();
    String chatRoomId = ids.join('_');
    await _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages').get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });}

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

    notifyListeners();
  }
}
// get messages
