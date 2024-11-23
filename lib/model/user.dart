
class UserData {
  String? uid;
  String? name;
  String? email;



  UserData({required this.uid,required this.name,required this.email});


  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
  };


  factory UserData.fromMap(Map<String, dynamic> map) => UserData(
    uid: map['uid'],
    name: map['name'],
    email: map['email'],
  );

  //from json
  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    uid: json['uid'],
    name: json['name'],
    email: json['email'],
  );
}