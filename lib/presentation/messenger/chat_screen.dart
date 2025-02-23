import 'dart:async';

import 'package:dating_app/models/conversation_model.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/conversation_provider.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String userId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserPhotoUrl;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserPhotoUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isLikeMessage = false;
  bool isMessageEmpty = true;

  StreamSubscription? _messagesSubscription;

  @override
  void initState() {
    super.initState();
    connectSocket();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<ConversationProvider>(context, listen: false)
          .getMessages(widget.userId, widget.otherUserId, context);
    });
  }

  void connectSocket() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    if (token == null || token.isEmpty) {
      print('❌ Token không hợp lệ, không kết nối socket');
      return;
    }

    socket = IO.io('http://192.168.100.137:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected!');
    });

    socket.on('new_message', (data) {
      print('New message: $data');
      Provider.of<ConversationProvider>(context, listen: false)
          .getMessages(widget.userId, widget.otherUserId, context);
      scrollToBottom();
    });

    socket.onDisconnect((_) {
      print('Disconnecte!!');
    });
  }

  Future<void> sendMessage() async {
    String messageText = _messageController.text.trim();
    if (messageText.isEmpty && !isLikeMessage) return;

    final String messageContent = isLikeMessage ? "👍" : messageText;

    SendMessageModel model = SendMessageModel(
        senderId: widget.userId,
        receiverId: widget.otherUserId,
        messageContent: messageContent);

    bool sent = await Provider.of<ConversationProvider>(context, listen: false)
        .sendMessage(model, context);

    if (sent) {
      Provider.of<ConversationProvider>(context, listen: false)
          .getMessages(widget.userId, widget.otherUserId, context);
    }

    _messageController.clear();
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          shadowColor: Colors.black.withOpacity(0.3),
          elevation: 2,
          toolbarHeight: 65,
          surfaceTintColor: Colors.white,
          leadingWidth: 35,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: widget.otherUserPhotoUrl != null
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.otherUserPhotoUrl!),
                        radius: 19,
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey[700],
                        child: const Icon(Icons.person),
                      ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.otherUserName,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          leading: Container(
            margin: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.left_chevron,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
        body: Column(
          children: [
            Consumer<ConversationProvider>(
                builder: (context, conversationProvider, child) {
              final messages = conversationProvider
                      .listMessage?.messages?.reversed
                      .toList() ??
                  [];
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSentByCurrentUser =
                        message.senderId == widget.userId;
                    return Align(
                      alignment: isSentByCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSentByCurrentUser
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isSentByCurrentUser
                                ? const Radius.circular(12)
                                : Radius.zero,
                            bottomRight: isSentByCurrentUser
                                ? Radius.zero
                                : const Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message.messageContent),
                            const SizedBox(height: 5),
                            Text(
                              DateFormat('h:mm a').format(
                                  DateTime.parse(message.createdAt).toLocal()),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(bottom: 15),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.camera_fill),
                    onPressed: () {},
                    padding: const EdgeInsets.all(10),
                    iconSize: 28,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  IconButton(
                    icon: const Icon(CupertinoIcons.photo_fill),
                    onPressed: () {},
                    padding: const EdgeInsets.all(10),
                    iconSize: 28,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(width: 10),

                  // Expanded TextField for typing the message
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 10),
                          hintText: 'Type a message...',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          setState(() {
                            isMessageEmpty = text.trim().isEmpty;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  _messageController.value.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            sendMessage();
                          },
                          padding: const EdgeInsets.all(10),
                          icon: Icon(
                            FluentSystemIcons.ic_fluent_send_filled,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              isLikeMessage = true;
                            });
                            sendMessage();
                          },
                          padding: const EdgeInsets.all(10),
                          icon: Icon(
                            Icons.thumb_up,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
