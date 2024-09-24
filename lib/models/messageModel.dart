import 'package:flutter/material.dart';

class messageModel {
  String? msg;
  String? read;
  String? told;
  Type? type;
  String? sent;
  String? fromId;

  messageModel(
      {this.msg, this.read, this.told, this.type, this.sent, this.fromId});

  messageModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.Image.name ? Type.Image : Type.Text;
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['read'] = this.read;
    data['told'] = this.told;
    data['type'] = this.type;
    data['sent'] = this.sent;
    data['fromId'] = this.fromId;
    return data;
  }
}

enum Type { Text, Image }
