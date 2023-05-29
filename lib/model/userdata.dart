// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appwrite_test/model/todo_dto.dart';

class UserData {
  String username;
  String password;

  UserData({
    required this.username,
    required this.password,
  });
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      password: json['password'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}
