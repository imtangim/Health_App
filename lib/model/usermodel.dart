// ignore_for_file: non_constant_identifier_names, duplicate_ignore

class UserModel {
  final String name;
  final String email;
  final String uid;
  final String profilePic;
  // ignore: non_constant_identifier_names
  final dynamic body_temp;
  final dynamic hearth_rate;
  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.profilePic,
    required this.body_temp,
    required this.hearth_rate,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? uid,
    String? profilePic,
    dynamic body_temp,
    // ignore: non_constant_identifier_names
    dynamic hearth_rate,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      body_temp: body_temp ?? this.body_temp,
      hearth_rate: hearth_rate ?? this.hearth_rate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'uid': uid,
      'profilePic': profilePic,
      'body_temp': body_temp,
      'hearth_rate': hearth_rate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      body_temp: map['body_temp'] as dynamic,
      hearth_rate: map['hearth_rate'] as dynamic,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, uid: $uid, profilePic: $profilePic, body_temp: $body_temp, hearth_rate: $hearth_rate)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.uid == uid &&
        other.profilePic == profilePic &&
        other.body_temp == body_temp &&
        other.hearth_rate == hearth_rate;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        uid.hashCode ^
        profilePic.hashCode ^
        body_temp.hashCode ^
        hearth_rate.hashCode;
  }
}
