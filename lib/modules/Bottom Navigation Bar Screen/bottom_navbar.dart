import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Add New Posts/add_new_post_screen.dart';
import 'Chats Screen/chats_screen.dart';
import 'Chats Screen/recent_chat.dart';
import 'Home Screen/home_screen.dart';
import 'Notification Screen/notification_screen.dart';
import 'Profile Screen/profile_screen.dart'; // Import your necessary screens

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  BottomNavBarScreenState createState() => BottomNavBarScreenState();
}

class BottomNavBarScreenState extends State<BottomNavBarScreen> {
  late int currentPage;
  final List<Color> colors = [
    Colors.yellow,
    Colors.pink,
    Colors.green,
    Colors.blue,
    Colors.red,
  ];

  @override
  void initState() {
    currentPage = 0;
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            IndexedStack(
              index: currentPage,
              children: [
                const HomeScreen(),
                NotificationScreen(),
                const AddScreen(),
                const ChatsScreen(),
                const ProfileScreen(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 30, right: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    5,
                        (index) => IconButton(
                      onPressed: () => changePage(index),
                      icon: Icon(
                        index == 0
                            ? Icons.home
                            : index == 1
                            ? Icons.notifications_sharp
                            : index == 2
                            ? Icons.add
                            : index == 3
                            ? Icons.chat_bubble
                            : CupertinoIcons.profile_circled,
                        color: index == currentPage
                            ? colors[index]
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
