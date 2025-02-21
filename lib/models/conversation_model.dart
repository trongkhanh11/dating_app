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
  final UserInChat user1;
  final UserInChat user2;
  final Message lastMessage;

  Conversation({
    required this.id,
    required this.user1,
    required this.user2,
    required this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      user1: UserInChat.fromJson(json['user1']),
      user2: UserInChat.fromJson(json['user2']),
      lastMessage: Message.fromJson(json['lastMessage']),
    );
  }
}

class ListMessage {
  List<Message>? messages;

  ListMessage({this.messages});

  factory ListMessage.fromJson(Map<String, dynamic> json) {
    return ListMessage(
      messages: json["data"] != null
          ? List<Message>.from(json["data"].map((x) => Message.fromJson(x)))
          : [],
    );
  }
}

class Message {
  final String id;
  final String messageContent;
  final String status;
  final String? readAt;
  final String senderId;
  final String receiverId;
  final String createdAt;

  Message({
    required this.id,
    required this.messageContent,
    required this.status,
    this.readAt,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
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

class SendMessageModel {
  final String senderId;
  final String receiverId;
  final String messageContent;

  SendMessageModel({
    required this.senderId,
    required this.receiverId,
    required this.messageContent,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageContent': messageContent,
    };
  }
}
