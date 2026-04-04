import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/routes/app_pages.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Subscribe to 'all' topic so admin can send to everyone
    if (!kIsWeb) {
      FirebaseMessaging.instance.subscribeToTopic('all_users');
    }

    // Request permissions for iOS/Android 13+
    await FirebaseMessaging.instance.requestPermission();
  } catch (e) {
    debugPrint('Firebase Initialization Error: $e');
    debugPrint(
        'If you are running on Web, you need to provide FirebaseOptions or run flutterfire configure.');
  }

  runApp(
    GetMaterialApp(
      title: 'Deal Bridge',
      // initialRoute: AppPages.INITIAL,
      // getPages: AppPages.routes,

      initialRoute: Routes.ADMIN,
      getPages: AppPages.routes,

      theme: ThemeData(
        fontFamily: 'Inter', // Optional, nice fallback1
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
