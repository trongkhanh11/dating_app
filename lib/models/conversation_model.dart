import 'package:dating_app/models/user_model.dart';

class ListConversation {
  List<Conversation>? conversations;

  ListConversation({this.conversations});

  factory ListConversation.fromJson(Map<String, dynamic> json) {
    return ListConversation(
      conversations: json["data"] != null
          ? List<Conversation>.from(
              json["data"].map((x) => Conversation.fromJson(x)))
          : [],
    );
  }
}

class Conversation {
  final String id;
  final User user1;
  final User user2;
  final LastMessage lastMessage;

  Conversation({
    required this.id,
    required this.user1,
    required this.user2,
    required this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      user1: User.fromJson(json['user1']),
      user2: User.fromJson(json['user2']),
      lastMessage: LastMessage.fromJson(json['lastMessage']),
    );
  }
}

class LastMessage {
  final int id;
  final String messageContent;
  final String status;
  final String? readAt;
  final String senderId;
  final String receiverId;
  final String createdAt;

  LastMessage({
    required this.id,
    required this.messageContent,
    required this.status,
    this.readAt,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['id'],
      messageContent: json['messageContent'],
      status: json['status'],
      readAt: json['readAt'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      createdAt: json['createdAt'],
    );
  }
}
