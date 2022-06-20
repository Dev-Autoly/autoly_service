// To parse this JSON data, do
//
//     final error = errorFromJson(jsonString);

import 'dart:convert';

Error errorFromJson(String str) => Error.fromJson(json.decode(str));

String errorToJson(Error data) => json.encode(data.toJson());

class Error {
  Error({
    this.success,
    this.statusCode,
    this.code,
    this.message,
    this.data,
  });

  bool success;
  int statusCode;
  String code;
  String message;
  List<dynamic> data;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    success: json["success"],
    statusCode: json["statusCode"],
    code: json["code"],
    message: json["message"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
