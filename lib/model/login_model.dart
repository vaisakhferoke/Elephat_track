// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

class LoginResponse {
  LoginResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  List<User>? data;
  String message;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<User>.from(json["data"].map((x) => User.fromJson(x))),
        message: json["message"],
      );
}

class User {
  User({
    required this.id,
    required this.elephantName,
    required this.elephantNo,
    required this.contactPerson,
    required this.contactPersonNumber,
    required this.username,
    required this.password,
    required this.currentLocation,
    required this.lat,
    required this.log,
    required this.lastLocationDatetime,
  });

  String id;
  String elephantName;
  String elephantNo;
  String contactPerson;
  String contactPersonNumber;
  String username;
  String password;
  String currentLocation;
  String lat;
  String log;
  DateTime lastLocationDatetime;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        elephantName: json["elephant_name"],
        elephantNo: json["elephant_no"],
        contactPerson: json["contact_person"],
        contactPersonNumber: json["contact_person_number"],
        username: json["username"],
        password: json["password"],
        currentLocation: json["current_location"],
        lat: json["lat"],
        log: json["log"],
        lastLocationDatetime: DateTime.parse(json["last_location_datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "elephant_name": elephantName,
        "elephant_no": elephantNo,
        "contact_person": contactPerson,
        "contact_person_number": contactPersonNumber,
        "username": username,
        "password": password,
        "current_location": currentLocation,
        "lat": lat,
        "log": log,
        "last_location_datetime": lastLocationDatetime.toIso8601String(),
      };
}
