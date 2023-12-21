import 'package:bhyapp/features/splash/presentation/splash_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission(provisional: true);
  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) {
    // APNS token is available, make FCM plugin API requests...
  }
  final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  print(fcmToken);
  runApp(const Albaraka());
}

class Albaraka extends StatelessWidget {
  const Albaraka({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade700)),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        /*inputDecorationTheme: InputDecorationTheme(
            outlineBorder: BorderSide(
              color: Colors.red
            )
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white
          ),
          bottomSheetTheme: BottomSheetThemeData(
              surfaceTintColor: Colors.lightGreen.shade400,
          )*/
      ),
      home: const SplashView(),
    );
  }
}
