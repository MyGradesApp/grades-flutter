import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Status {
  String status;
  String message;

  Status(this.status, this.message);

  factory Status.fromJson(dynamic json) {
    return Status(json['status'] as String, json['message'] as String);
  }
}

Future<Status> getStatus() async {
  var response = await http.get('https://swiftgrade.github.io/status/');
  print(response.body);
  if (response.body.isNotEmpty) {
    var stat = Status.fromJson(jsonDecode(response.body));
    return stat;
  }
  return null;
}

Widget getStatusCard(String message) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color.fromARGB(255, 211, 117, 116),
      child: Padding(
        padding: const EdgeInsets.only(left: 3, top: 15, right: 3, bottom: 15),
        child: SizedBox(
          width: double.infinity,
          child: Row(children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ]),
        ),
      ),
    ),
  );
}
