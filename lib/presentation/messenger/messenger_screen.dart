import 'dart:async';

import 'package:dating_app/presentation/messenger/chat_screen.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/conversation_provider.dart';
import 'package:dating_app/themes/theme.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;
  bool isSearchMode = false;
  String userId = "";
  StreamSubscription? _chatStreamSubscription;
  final TextEditingController _searchController = TextEditingController();

  // void fetchChats(String userId) {
  //   final databaseReference = FirebaseDatabase.instance.ref().child('chats');
  //   _chatStreamSubscription = databaseReference.onValue.listen((event) async {
  //     if (!mounted) return;

  //     if (event.snapshot.exists) {
  //       final chatIds =
  //           event.snapshot.children.map((child) => child.key!).toList();

  //       final futures = chatIds.map((chatId) async {
  //         final lastMessageSnapshot = await databaseReference
  //             .child('$chatId/messages')
  //             .orderByChild('timestamp')
  //             .limitToLast(1)
  //             .get();

  //         if (lastMessageSnapshot.exists) {
  //           final lastMessage = lastMessageSnapshot.children.first.value as Map;
  //           final membersSnapshot =
  //               event.snapshot.child(chatId).child('members');
  //           final members = membersSnapshot.value is Map
  //               ? Map<String, dynamic>.from(membersSnapshot.value as Map)
  //               : {};
  //           final memberIds =
  //               members.values.cast<Map>().expand((e) => e.keys).toList();

  //           if (memberIds.contains(userId)) {
  //             final otherMemberId = memberIds.firstWhere((id) => id != userId,
  //                 orElse: () => null);
  //             if (otherMemberId == null) {
  //               return null;
  //             }
  //             final userDoc = await FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(otherMemberId)
  //                 .get();
  //             final sender = await FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(lastMessage['sender'])
  //                 .get();

  //             if (userDoc.exists && sender.exists) {
  //               final userData = userDoc.data()!;
  //               final senderData = sender.data()!;

  //               return {
  //                 'chatId': chatId,
  //                 'otherUserId': userData['id'] ?? '',
  //                 'name': userData['displayName'] ?? 'Unknown',
  //                 'photoUrl': userData['photoUrl'],
  //                 'lastMessage': lastMessage['message'] ?? 'No messages',
  //                 'timestamp': lastMessage['timestamp'] ?? 0,
  //                 'sender': senderData['displayName'] ?? 'Unknown',
  //                 'senderId': lastMessage['sender'],
  //               };
  //             }
  //           }
  //         }
  //         return null;
  //       }).toList();

  //       final results = await Future.wait(futures);
  //       if (mounted) {
  //         setState(() {
  //           chats = results.whereType<Map<String, dynamic>>().toList();
  //           isLoading = false;
  //         });
  //       }
  //     }
  //   });
  // }

  // Future<void> fetchUsers() async {
  //   if (mounted) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //   }

  //   final userDocs = await FirebaseFirestore.instance.collection('users').get();
  //   final userData = userDocs.docs
  //       .map((doc) => {
  //             'id': doc.id,
  //             'displayName': doc.data()['displayName'] ?? 'Unknown',
  //             'photoUrl': doc.data()['photoUrl'],
  //           })
  //       .toList();

  //   if (mounted) {
  //     setState(() {
  //       users = userData;
  //       filteredUsers = userData;
  //       isLoading = false;
  //     });
  //   }
  // }

  void _filterUsers(String query) {
    if (mounted) {
      setState(() {
        filteredUsers = users
            .where((user) =>
                user['displayName'] != null &&
                user['displayName']!
                    .replaceAll(RegExp(r'\s+'), '')
                    .toLowerCase()
                    .contains(
                        query.replaceAll(RegExp(r'\s+'), '').toLowerCase()))
            .toList();
      });
    }
  }

  // Future<String> getChatId(String userId, String otherUserId) async {
  //   final databaseReference = FirebaseDatabase.instance.ref();

  //   final chat =
  //       await databaseReference.child('chats/${otherUserId}_$userId').get();
  //   if (chat.exists) {
  //     return '${otherUserId}_$userId';
  //   }

  //   return '${userId}_$otherUserId';
  // }

  // void openChat(String userId, String otherUserId, String otherUserName,
  //     String? otherUserPhotoUrl) async {
  //   final chatId = await getChatId(userId, otherUserId);

  //   Navigator.push(
  //     // ignore: use_build_context_synchronously
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ChatScreen(
  //         chatId: chatId,
  //         userId: userId,
  //         otherUserId: otherUserId,
  //         otherUserName: otherUserName,
  //         otherUserPhotoUrl: otherUserPhotoUrl,
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      userId = authProvider.userModel?.user.id ?? "";
      Provider.of<ConversationProvider>(context, listen: false)
          .getListConversation(userId, context);
    });
  }

  @override
  void dispose() {
    _chatStreamSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (isSearchMode && mounted) {
          setState(() {
            isSearchMode = !isSearchMode;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.colors.bgColor,
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: AppTheme.colors.bgColor,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Messenger",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: TextField(
                        onTap: () {
                          if (!isSearchMode && mounted) {
                            setState(() {
                              isSearchMode = !isSearchMode;
                            });
                          }
                        },
                        controller: _searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: "Search",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                          prefixIcon: Icon(
                            FluentSystemIcons.ic_fluent_search_filled,
                            color: Colors.grey[700],
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              style: BorderStyle.none,
                              width: 0,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        onChanged: _filterUsers,
                      ),
                    ),
                  ),
                  isSearchMode
                      ? IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                isSearchMode = !isSearchMode;
                                _searchController.clear();
                              });
                            }
                            FocusScope.of(context).unfocus();
                          }, // Cancel search
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is ScrollUpdateNotification) {
                          FocusScope.of(context).unfocus();
                        }
                        return true;
                      },
                      child: isSearchMode
                          ? ListView.builder(
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = filteredUsers[index];
                                return ListTile(
                                  minVerticalPadding: 20,
                                  leading: user['photoUrl'] != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(user['photoUrl']!),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.grey[700],
                                          child: const Icon(Icons.person)),
                                  title: Text(
                                    user['displayName']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    // openChat(userId, user['id'],
                                    //     user['displayName'], user['photoUrl']);
                                  },
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: chats.length,
                              itemBuilder: (context, index) {
                                final chat = chats[index];
                                return ListTile(
                                  leading: chat['photoUrl'] != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(chat['photoUrl']!),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.grey[700],
                                          child: const Icon(Icons.person)),
                                  title: Text(
                                    chat['name']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    chat['lastMessage']!.contains(
                                            'https://www.google.com/maps')
                                        ? chat['senderId'] == userId
                                            ? "You sent a location."
                                            : "${chat['sender']} sent a location."
                                        : chat['lastMessage']!.contains(
                                                'https://firebasestorage.googleapis.com/v0/b/vermelha-88923.appspot.com/o/chat-images')
                                            ? chat['senderId'] == userId
                                                ? "You sent a photo."
                                                : "${chat['sender']} sent a photo."
                                            : chat['senderId'] == userId
                                                ? "You: ${chat['lastMessage']!}"
                                                : chat['lastMessage']!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  trailing: Text(
                                    DateFormat('h:mm a')
                                        .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                          chat['timestamp'],
                                        ).toLocal())
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          chatId: chat['chatId'],
                                          userId: userId,
                                          otherUserId: chat['otherUserId'],
                                          otherUserName: chat['name'],
                                          otherUserPhotoUrl: chat['photoUrl'],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
