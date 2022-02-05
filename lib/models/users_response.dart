// To parse this JSON data, do
//
//     final usersResponse = usersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/user_model.dart';

class UsersResponse {
    UsersResponse({
        required this.ok,
        required this.users,
    });

    bool ok;
    List<User> users;

    factory UsersResponse.fromRawJson(String str) => UsersResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        ok: json["ok"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
    };
}

