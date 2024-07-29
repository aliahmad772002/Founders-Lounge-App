import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/modules/Bottom%20Navigation%20Bar%20Screen/bottom_navbar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login Screen/login_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(() => const LoginIn(), transition: Transition.rightToLeft);
    });


  }

  void getdatafromSF() async {
    print('Inside getdatafromSF');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('uid');
    print('UID from SharedPreferences: $value');

    if (value != null) {
      StaticData.uid = value;
      print('UID is not null. Navigating to HomeScreen');
      Get.to(() => const BottomNavBarScreen(), transition: Transition.zoom);
    } else {
      print('uid is null. Navigating to LoginScreen');
      Get.to(() => const LoginIn(), transition: Transition.zoom);
    }
  }



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: const Center(
          child: Text('Founders Lounge'),
        ),
      ),
    );
  }
}
