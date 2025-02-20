import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/presentation/loveScreen/love_card.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/interaction_provider.dart';
import 'package:dating_app/providers/profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoveScreen extends StatefulWidget {
  const LoveScreen({super.key});

  @override
  _LoveScreenState createState() => _LoveScreenState();
}

class _LoveScreenState extends State<LoveScreen> {
  List<Profile> listUserProfiles = [];
  String userId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadLikeProfiles();
    });
  }

  void _loadLikeProfiles() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final interactionProvider =
        Provider.of<InteractionProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    userId = authProvider.userModel?.user.id ?? '';
    await interactionProvider.getRecievedLikes(userId, context);



    List<Profile> tempProfiles = [];
    for (var interaction in interactionProvider.interactionLike?.data ?? []) {
      await profileProvider.getUserProfile(interaction.senderUserId, context);
      if (profileProvider.profile != null) {
        tempProfiles.add(profileProvider.profile!);
      }
    }

    setState(() {
      listUserProfiles = tempProfiles;
    });
  }

  void removeUser(int index) {
    setState(() {
      listUserProfiles.removeAt(index);
    });
  }

  void acceptUser(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              "Bạn đã match với ${listUserProfiles[index].displayName}! ❤️")),
    );
    removeUser(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Love List",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.redAccent.shade100, Colors.purple.shade400]),
        ),
        child: Column(
          children: [
            SizedBox(height: 100),
            if (listUserProfiles.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sentiment_dissatisfied,
                          size: 80, color: Colors.white),
                      SizedBox(height: 10),
                      Text("Không có ai trong danh sách 😢",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  itemCount: listUserProfiles.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(listUserProfiles[index].id),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(Icons.check, color: Colors.white, size: 30),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(Icons.close, color: Colors.white, size: 30),
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          acceptUser(index);
                        } else {
                          removeUser(index);
                        }
                      },
                      child: LoveCard(profile: listUserProfiles[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
