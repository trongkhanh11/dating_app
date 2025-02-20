import 'dart:async';
import 'dart:io';

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserPhotoUrl;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.userId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserPhotoUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<File> selectedImages = [];
  bool isLikeMessage = false;
  bool isSendingImage = false;
  bool isMessageEmpty = true;

  List<Map<String, dynamic>> messages = [];
  StreamSubscription? _messagesSubscription;

  Future<void> fetchMessages() async {
    // final databaseReference = FirebaseDatabase.instance.ref();
    // final messagesRef =
    //     databaseReference.child('chats/${widget.chatId}/messages');

    // _messagesSubscription =
    //     messagesRef.orderByChild('timestamp').onValue.listen((event) {
    //   if (!mounted) return;

    //   if (event.snapshot.exists) {
    //     List<Map<String, dynamic>> messageData = [];
    //     for (var childSnapshot in event.snapshot.children) {
    //       var message = childSnapshot.value as Map;
    //       messageData.add({
    //         'sender': message['sender'],
    //         'message': message['message'],
    //         'timestamp': message['timestamp'],
    //       });
    //     }

    //     setState(() {
    //       messages = messageData;
    //     });

    //     scrollToBottom();
    //   }
    // });
  }

  Future<void> sendMessage([String? imageUrl]) async {
    String messageText = _messageController.text.trim();
    // if (messageText.isEmpty && imageUrl == null && !isLikeMessage) return;

    // final databaseReference = FirebaseDatabase.instance.ref();
    // const timestamp = ServerValue.timestamp;

    // final String message =
    //     messageText.isEmpty && imageUrl == null && isLikeMessage
    //         ? "👍"
    //         : imageUrl ?? messageText;

    // final newMessage = {
    //   'sender': widget.userId,
    //   'message': message,
    //   'timestamp': timestamp,
    // };

    // final members = {
    //   widget.userId: true,
    //   widget.otherUserId: true,
    // };

    // await databaseReference
    //     .child('chats/${widget.chatId}/messages')
    //     .push()
    //     .set(newMessage);

    // await databaseReference
    //     .child('chats/${widget.chatId}/members')
    //     .push()
    //     .set(members);

    // if (message != imageUrl) {
    //   _messageController.clear();
    // }

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
  void initState() {
    super.initState();
    fetchMessages();
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
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isSentByCurrentUser =
                      message['sender'] == widget.userId;
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
                          Text(message['message']),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('h:mm a')
                                .format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    message['timestamp'],
                                    isUtc: true,
                                  ).toLocal(),
                                )
                                .toString(),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (selectedImages.isNotEmpty)
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    final image = selectedImages[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Stack(
                        children: [
                          Image.file(
                            File(image.path),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.cancel, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  selectedImages.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
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

                  _messageController.value.text.isNotEmpty && !isMessageEmpty ||
                          selectedImages.isNotEmpty
                      ? isSendingImage
                          ? const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            )
                          : IconButton(
                              onPressed: () async {
                                // if (selectedImages.isNotEmpty) {
                                //   await sendImages();
                                // } else {
                                //   await sendMessage();
                                // }
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
