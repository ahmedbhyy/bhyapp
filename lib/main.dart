import 'dart:io';

import 'package:bhyapp/features/splash/presentation/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Albaraka());
}

class Albaraka extends StatefulWidget {
  const Albaraka({super.key});

  @override
  State<Albaraka> createState() => _AlbarakaState();
}

class _AlbarakaState extends State<Albaraka> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    if(Platform.isAndroid) {
      OneSignal.initialize("19ca5fd9-1a46-413f-9209-d77a7d63dde0");
      OneSignal.Notifications.clearAll();
      OneSignal.User.pushSubscription.optIn();
      await OneSignal.Notifications.requestPermission(true);
    }

  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade700)),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const SplashView(),
    );
  }
}
