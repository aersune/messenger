
class UserData {
  String uid;
  String name;
  String email;
  bool isOnline;
  String imageUrl;


  UserData({required this.uid,required this.name,required this.email, required this.isOnline, required this.imageUrl});


  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'isOnline': isOnline,
    'photoUrl': imageUrl,
  };


  factory UserData.fromMap(Map<String, dynamic> map) => UserData(
    uid: map['uid'],
    name: map['name'],
    email: map['email'],
    isOnline: map['isOnline'],
    imageUrl: map['photoUrl'],
  );

  //from json
  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    uid: json['uid'],
    name: json['name'],
    email: json['email'],
    isOnline: json['isOnline'],
    imageUrl: json['photoUrl'],
  );
}