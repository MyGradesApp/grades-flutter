import 'dart:convert';

import 'package:http/http.dart' as http;

class Status {
  String status;
  String message;

  Status(this.status, this.message);

  factory Status.fromJson(dynamic json) {
    return Status(json['Status'] as String, json['Message'] as String);
  }
}

Future<Status> getStatus() async {
  var response = await http.get('https://swiftgrade.github.io/status/');
  print(response.body);
  var stat = Status.fromJson(jsonDecode(response.body));
  return stat;
}
