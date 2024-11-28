
class UserData {
  String? uid;
  String? name;
  String? email;
  bool isOnline;



  UserData({required this.uid,required this.name,required this.email, required this.isOnline});


  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'isOnline': isOnline,
  };


  factory UserData.fromMap(Map<String, dynamic> map) => UserData(
    uid: map['uid'],
    name: map['name'],
    email: map['email'],
    isOnline: map['isOnline'],
  );

  //from json
  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    uid: json['uid'],
    name: json['name'],
    email: json['email'],
    isOnline: json['isOnline'],
  );
}