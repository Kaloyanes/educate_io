// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sender;
  DateTime time;
  String value;
  String msgId;
  Message({
    required this.sender,
    required this.time,
    required this.value,
    required this.msgId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'time': time.millisecondsSinceEpoch,
      'value': value,
      'msgId': msgId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(
          (map['time'] as Timestamp).millisecondsSinceEpoch),
      value: map['value'] as String,
      msgId: map['msgId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(sender: $sender, time: $time, value: $value, msgId: $msgId)';
  }

  @override
  bool operator ==(covariant Message other) {
    // if (identical(this, other)) return true;

    return other.sender == sender &&
        other.time == time &&
        other.value == value &&
        other.msgId == msgId;
  }

  Message copyWith({
    String? sender,
    DateTime? time,
    String? value,
    String? msgId,
  }) {
    return Message(
      sender: sender ?? this.sender,
      time: time ?? this.time,
      value: value ?? this.value,
      msgId: msgId ?? this.msgId,
    );
  }

  @override
  int get hashCode {
    return sender.hashCode ^ time.hashCode ^ value.hashCode ^ msgId.hashCode;
  }
}
