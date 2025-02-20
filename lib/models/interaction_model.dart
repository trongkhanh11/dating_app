class Interaction {
  final String senderId;
  final String receiverId;
  final String type;

  Interaction({
    required this.senderId,
    required this.receiverId,
    required this.type,
  });

  factory Interaction.fromJson(Map<String, dynamic> json) {
    return Interaction(
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
