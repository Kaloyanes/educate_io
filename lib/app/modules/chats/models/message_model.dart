// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sender;
  DateTime time;
  dynamic value;
  String msgId;
  bool? isEdited;
  String? type;

  Message({
    required this.sender,
    required this.time,
    required this.value,
    required this.msgId,
    required this.isEdited,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'time': time.millisecondsSinceEpoch,
      'value': value,
      'msgId': msgId,
      'isEdited': isEdited,
      'type': type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(
          (map['time'] as Timestamp).millisecondsSinceEpoch),
      value: map['value'] as dynamic,
      msgId: map['msgId'] as String,
      isEdited: map['isEdited'] != null ? map['isEdited'] as bool : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(sender: $sender, time: $time, value: $value, msgId: $msgId, isEdited: $isEdited, type: $type)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.sender == sender &&
        other.time == time &&
        other.value == value &&
        other.msgId == msgId &&
        other.isEdited == isEdited &&
        other.type == type;
  }

  Message copyWith({
    String? sender,
    DateTime? time,
    dynamic value,
    String? msgId,
    bool? isEdited,
    String? type,
  }) {
    return Message(
      sender: sender ?? this.sender,
      time: time ?? this.time,
      value: value ?? this.value,
      msgId: msgId ?? this.msgId,
      isEdited: isEdited ?? this.isEdited,
      type: type ?? this.type,
    );
  }

  @override
  int get hashCode {
    return sender.hashCode ^
        time.hashCode ^
        value.hashCode ^
        msgId.hashCode ^
        isEdited.hashCode ^
        type.hashCode;
  }
}
