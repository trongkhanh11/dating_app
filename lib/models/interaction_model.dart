class Interaction {
  final String id;
  final String senderUserId;
  final String receiverUserId;
  final String type;
  final String createdAt;

  Interaction({
    required this.id,
    required this.senderUserId,
    required this.receiverUserId,
    required this.type,
    required this.createdAt,
  });

  factory Interaction.fromJson(Map<String, dynamic> json) {
    return Interaction(
      id: json['id'],
      senderUserId: json['senderUserId'],
      receiverUserId: json['receiverUserId'],
      type: json['type'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderUserId,
      'receiverId': receiverUserId,
      'type': type,
      'createdAt': createdAt,
    };
  }
}

class InteractModel {
  final String senderId;
  final String receiverId;
  final String type;

  InteractModel({
    required this.senderId,
    required this.receiverId,
    required this.type,
  });

  factory InteractModel.fromJson(Map<String, dynamic> json) {
    return InteractModel(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
    };
  }
}
