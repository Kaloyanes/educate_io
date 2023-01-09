import 'dart:convert';

import 'package:educate_io/app/modules/chats/models/message_model.dart';
import 'package:flutter/foundation.dart';

class Chat {
  List<Message> messages;
  Chat({
    required this.messages,
  });

  Chat copyWith({
    List<Message>? messages,
  }) {
    return Chat(
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      messages: List<Message>.from(
        (map['messages'] as List<int>).map<Message>(
          (x) => Message.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Chat(messages: $messages)';

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return listEquals(other.messages, messages);
  }

  @override
  int get hashCode => messages.hashCode;
}
