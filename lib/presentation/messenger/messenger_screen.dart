import 'package:dating_app/models/user_model.dart';
import 'package:dating_app/presentation/messenger/chat_screen.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/conversation_provider.dart';
import 'package:dating_app/providers/profile_provider.dart';
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
  bool isSearchMode = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userModel?.user.id ?? "";
      await Provider.of<ConversationProvider>(context, listen: false)
          .getListConversation(userId, context);
    });
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp).toLocal();
    DateTime now = DateTime.now();

    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    return isToday
        ? DateFormat('HH:mm').format(dateTime)
        : DateFormat('dd-MM').format(dateTime);
  }

  @override
  void dispose() {
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
                        onChanged: (value) {},
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
            Consumer2<ConversationProvider, ProfileProvider>(builder:
                (context, conversationProvider, profileProvider, child) {
              final conversations =
                  conversationProvider.listConversation?.conversations ?? [];
              return Expanded(
                child: conversationProvider.isLoading
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
                                itemCount: conversations.length,
                                itemBuilder: (context, index) {
                                  final authProvider =
                                      Provider.of<AuthProvider>(context,
                                          listen: false);
                                  final userId =
                                      authProvider.userModel?.user.id ?? "";

                                  final UserInChat user;
                                  if (userId == conversations[index].user1.id) {
                                    user = conversations[index].user1;
                                  } else {
                                    user = conversations[index].user2;
                                  }

                                  return ListTile(
                                    minVerticalPadding: 20,
                                    leading: user.image != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(user.image!),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Colors.grey[700],
                                            child: const Icon(Icons.person)),
                                    title: Text(
                                      user.displayName,
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
                                itemCount: conversations.length,
                                itemBuilder: (context, index) {
                                  final user = conversations[index].user2;
                                  return ListTile(
                                    leading: user.image != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(user.image!),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Colors.grey[700],
                                            child: const Icon(Icons.person)),
                                    title: Text(
                                      user.displayName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      conversations[index]
                                                  .lastMessage
                                                  .senderId ==
                                              conversations[index].user1.id
                                          ? "You: ${conversations[index].lastMessage.messageContent}"
                                          : conversations[index]
                                              .lastMessage
                                              .messageContent,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    trailing: Text(
                                      formatTimestamp(conversations[index]
                                          .lastMessage
                                          .createdAt),
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            chatId: conversations[index].id,
                                            userId:
                                                conversations[index].user1.id,
                                            otherUserId:
                                                conversations[index].user2.id,
                                            otherUserName: user.displayName,
                                            otherUserPhotoUrl: user.image,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
