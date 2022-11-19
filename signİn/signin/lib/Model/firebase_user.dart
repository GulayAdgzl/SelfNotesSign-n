class FirebaseUser {
  String? kind;
  String? localId;
  String? email;
  String? displayName;
  String? idToken;
  bool? registered;
  String? refreshToken;
  String? expiresIn;

  FirebaseUser(
      {required this.kind,
      required this.localId,
      required this.email,
      required this.displayName,
      required this.idToken,
      required this.registered,
      required this.refreshToken,
      required this.expiresIn});

  FirebaseUser.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    localId = json['localId'];
    email = json['email'];
    displayName = json['displayName'];
    idToken = json['idToken'];
    registered = json['registered'];
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['localId'] = this.localId;
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['idToken'] = this.idToken;
    data['registered'] = this.registered;
    data['refreshToken'] = this.refreshToken;
    data['expiresIn'] = this.expiresIn;
    return data;
  }
}
