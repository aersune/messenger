import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserStatus {
  final String status;
  final dynamic timestamp;

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

  factory UserStatus.fromJson(Map<dynamic, dynamic> json) {
    return UserStatus(
      status: json['status'] ?? '',
      timestamp: json['timestamp'] ?? '',
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
      'status': 'online',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void _updateStatus() {
    _databaseRef.child('status').child(_auth.currentUser!.uid).set({
      'status': 'online',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((value) {
      if (kDebugMode) {
        print('Status updated successfully');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to update status: $error');
      }
    });

  }

  void _onAuthStateChange() {
    _auth.authStateChanges().listen((User? user) {
      _updateStatus();
    });
  }

  void _onDisconnect() {
    _databaseRef.child('status').child(_auth.currentUser!.uid).onDisconnect().set({
      'status': 'offline',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void init() {
    setData();
    _onAuthStateChange();
    _onDisconnect();
  }

  void update() {
    _onAuthStateChange();
    _onDisconnect();
  }

  @override
  void dispose() {
    _databaseRef.onDisconnect().cancel();
    super.dispose();
  }
}
