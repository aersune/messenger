import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserStatus {

  final String status;
  final int timestamp;

  UserStatus({
    required this.status,
    required this.timestamp,
  });

  factory UserStatus.fromMap(String userId, Map<dynamic, dynamic> data) {
    return UserStatus(
      status: data['status'] ?? '',
      timestamp: data['timestamp'] ?? '',
    );
  }
}

class UserStatusService with ChangeNotifier {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  bool isOnline = false;

  void readData() {
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref("status");
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
    });
  }

  void setData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("status/${_auth.currentUser!.uid}");
    await ref.set({
      'isOnline': 'online',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void _updateStatus() {
    _databaseRef.child('status').child(_auth.currentUser!.uid).set({
      'status': 'online',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((value) {
      print('Status updated successfully');
    }).catchError((error) {
      print('Failed to update status: $error');
    });
    print('update');
  }

  void _onAuthStateChange() {
    _auth.authStateChanges().listen((User? user) {
      _updateStatus();
    });
  }

  void _onDisconnect() {
    _databaseRef.child('status').child(_auth.currentUser!.uid).onDisconnect().set({
      'isOnline': 'offline',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void init() {
    setData();
    _onAuthStateChange();
    _onDisconnect();
  }

  @override
  void dispose() {
    _databaseRef.onDisconnect().cancel();
    super.dispose();
  }
}
