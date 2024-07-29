import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final currentUserID = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Stream builder to show the notifications but not the current user's notifications
        stream: firebaseFirestore
            .collection('notifications')
            .where('receiverID', isEqualTo: currentUserID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.docs.length); // To check the length of data
            print(snapshot.data!.docs); // To check the data (documents
            final notifications = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      notification['senderProfileImage'],
                    ),
                    radius: 25,
                  ),
                  title: Text(
                    notification['senderName'],
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  subtitle: Text(
                    notification['message'],
                    style: TextStyle(fontSize: 14),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
