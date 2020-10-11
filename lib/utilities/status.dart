import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Status {
  String status;

  Status(this.status);

  factory Status.fromJson(dynamic json) {
    return Status(json['status'] as String);
  }
}

Future<Status> getStatus() async {
  http.Response response;
  try {
    response = await http.get('https://swiftgrade.github.io/status/');
  } on SocketException catch (e) {
    return Future.error(e);
  }

  if (response != null && response.body.isNotEmpty) {
    var stat = Status.fromJson(jsonDecode(response.body));
    return stat;
  }
  return null;
}

Widget buildStatusCardWidget() {
  return FutureBuilder<Status>(
    future: getStatus(),
    builder: (BuildContext context, AsyncSnapshot<Status> snapshot) {
      if (snapshot != null && snapshot.hasData) {
        if (snapshot.data.status.toString().isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color.fromARGB(255, 211, 117, 116),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 3, top: 15, right: 3, bottom: 15),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        snapshot.data.status.toString(),
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
      }
      return Container();
    },
  );
}
