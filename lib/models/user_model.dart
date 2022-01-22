class User {
    User({
        required this.name,
        required this.email,
        required this.online,
        required this.uid,
    });

    String name;
    String email;
    bool online;
    String uid;

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        online: json["online"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "online": online,
        "uid": uid,
    };
}
