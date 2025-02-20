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

class InteractionLike {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<InteractionUserInfo> data;

  InteractionLike({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.data,
  });

  // Factory constructor từ JSON (Fix lỗi danh sách InteractionUserInfo)
  factory InteractionLike.fromJson(Map<String, dynamic> json) {
    return InteractionLike(
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      data: (json['data'] as List?)
              ?.map((item) => InteractionUserInfo.fromJson(item))
              .toList() ??
          [],
    );
  }

  // Convert về JSON
  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class InteractionUserInfo {
  final String id;
  final String senderUserId;
  final String receiverUserId;
  final String type;
  final String createdAt;

  // Constructor
  InteractionUserInfo({
    required this.id,
    required this.senderUserId,
    required this.receiverUserId,
    required this.type,
    required this.createdAt,
  });

  // Factory method để parse từ JSON
  factory InteractionUserInfo.fromJson(Map<String, dynamic> json) {
    return InteractionUserInfo(
      id: json['id'] ?? '',
      senderUserId: json['senderUserId'] ?? '',
      receiverUserId: json['receiverUserId'] ?? '',
      type: json['type'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  // Chuyển thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderUserId': senderUserId,
      'receiverUserId': receiverUserId,
      'type': type,
      'createdAt': createdAt,
    };
  }
}
