import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodappsales/mainscreen/earnings_screen.dart';
import 'package:foodappsales/mainscreen/history_screen.dart';
import 'package:foodappsales/mainscreen/home_screen.dart';
import 'package:foodappsales/authentication/auth_screen.dart';
import 'package:foodappsales/global/global.dart';
import 'package:foodappsales/mainscreen/new_order_screen.dart';
import 'package:foodappsales/splashscreen/splash_screen.dart';
import 'package:foodappsales/uploadscreens/items_upload_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mainscreen/items_screen.dart';
import 'uploadscreens/menus_upload_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Food Sales",
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        AuthScreen.id: (context) => const AuthScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ItemsScreen.id: (context) => const ItemsScreen(),
        MenusUploadScreen.id: (context) => const MenusUploadScreen(),
        ItemsUploadScreen.id: (context) => const ItemsUploadScreen(),
        NewOrderScreen.id: (context) => const NewOrderScreen(),
        HistoryScreen.id: (context) => const HistoryScreen(),
        EarningsScreen.id: (context) => const EarningsScreen()
      },
      initialRoute: SplashScreen.id,
    );
  }
}
