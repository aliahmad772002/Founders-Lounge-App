import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/modules/Bottom%20Navigation%20Bar%20Screen/bottom_navbar.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/notification_service.dart';
import 'modules/Splash Screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  requestPermissions();
  Get.put(FirebaseController());
  // Check if the user is logged in
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
FirebaseController.instance.getToken();
  initState();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const BottomNavBarScreen() : const SplashScreen(),
    ),
  );
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}
requestPermissions() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}
void initState() {



  FirebaseMessaging.instance.getInitialMessage().then(
        (message) {
      if (message != null) {
        // print(message);
      }
    },
  );
  // 2. This method only call when App in forground it mean app must be opened
  FirebaseMessaging.onMessage.listen(
        (message) {
      // print(message.data);
      if (message.notification != null) {
        LocalNotificationService.createAndDisplayChatNotification(message);
      }
    },
  );
  // 3. This method only call when App in background and not terminated(not closed)
  FirebaseMessaging.onMessageOpenedApp.listen(
        (message) {
      print('app open on click');
      print(message.notification!.body);
      print(message.notification!.title);
      print(message.data);
      if (message.notification != null) {}
    },
  );

}




