import 'package:dating_app/presentation/home/filter_screen.dart';
import 'package:dating_app/presentation/loveScreen/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoveScreen extends StatefulWidget {
  const LoveScreen({super.key});

  @override
  _LoveScreenState createState() => _LoveScreenState();
}

class _LoveScreenState extends State<LoveScreen> {
  List<User> allUsers = [
    User(
        name: "Anna",
        age: 25,
        distance: 5,
        imageUrl: "https://i.pravatar.cc/150?img=1"),
    User(
        name: "David",
        age: 27,
        distance: 10,
        imageUrl: "https://i.pravatar.cc/150?img=2"),
    User(
        name: "Sophia",
        age: 24,
        distance: 15,
        imageUrl: "https://i.pravatar.cc/150?img=3"),
    User(
        name: "Mark",
        age: 30,
        distance: 20,
        imageUrl: "https://i.pravatar.cc/150?img=4"),
  ];

  List<User> filteredUsers = [];

  double selectedDistance = 50; // Mặc định 50km
  RangeValues selectedAgeRange = RangeValues(18, 50); // Mặc định 18 - 50 tuổi

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(allUsers); // Hiển thị tất cả user ban đầu
  }

  void filterUsers() {
    setState(() {
      filteredUsers = allUsers.where((user) {
        return user.distance <= selectedDistance &&
            user.age >= selectedAgeRange.start &&
            user.age <= selectedAgeRange.end;
      }).toList();
    });
  }

  void _openFilterScreen() async {
    final result = await showModalBottomSheet<Map<String, double>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterScreen(
        minAge: selectedAgeRange.start,
        maxAge: selectedAgeRange.end,
        distance: selectedDistance,
      ),
    );

    if (result != null) {
      setState(() {
        selectedAgeRange = RangeValues(result['minAge']!, result['maxAge']!);
        selectedDistance = result['distance']!;
      });
      filterUsers();
    }
  }

  void removeUser(int index) {
    setState(() {
      filteredUsers.removeAt(index);
    });
  }

  void acceptUser(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Bạn đã match với ${filteredUsers[index].name} ❤️")),
    );
    setState(() {
      filteredUsers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Tăng chiều cao AppBar
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: AppBar(
            title: Text(
              "Love List",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(CupertinoIcons.slider_horizontal_3,
                    color: Colors.white),
                onPressed: _openFilterScreen,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent.shade100, Colors.purple.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 100),
            if (filteredUsers.isEmpty)
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
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(filteredUsers[index].name),
                      direction: DismissDirection.horizontal, // Vuốt hai hướng
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.green, // Vuốt phải: Đồng ý (Match)
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 30),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red, // Vuốt trái: Từ chối
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 30),
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          acceptUser(index);
                        } else {
                          removeUser(index);
                        }
                      },
                      child: LoveCard(user: filteredUsers[index]),
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

class LoveCard extends StatelessWidget {
  final User user;

  LoveCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: user),
                ),
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.imageUrl),
                radius: 30,
              ),
              title: Text(
                user.name,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              subtitle: Text("${user.age} tuổi • ${user.distance} km",
                  style: TextStyle(color: Colors.grey[700])),
              trailing: Icon(Icons.favorite, color: Colors.red, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}

class User {
  final String name;
  final int age;
  final int distance;
  final String imageUrl;

  User(
      {required this.name,
      required this.age,
      required this.distance,
      required this.imageUrl});
}
