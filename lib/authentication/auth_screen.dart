import 'package:flutter/material.dart';
import 'package:foodappsales/authentication/login_screen.dart';
import 'package:foodappsales/authentication/register_screen.dart';

class AuthScreen extends StatefulWidget {
  static String id = "authScreen";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            // begin: FractionalOffset(0.0, 0.0),
            // end: FractionalOffset(1.0, 0.0),
            // stops: [0.0, 1.0],
            // tileMode: TileMode.clamp,
          ))),
          title: const Text("iFood Sales",
              style: TextStyle(fontFamily: "Lobster", fontSize: 40)),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.lock), text: "Login"),
              Tab(icon: Icon(Icons.person), text: "Register"),
            ],
            indicatorColor: Colors.white70,
            indicatorWeight: 3,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.amber,
              Colors.cyan,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
          )),
          child: const TabBarView(children: [
            LoginScreen(),
            RegisterScreen(),
          ]),
        ),
      ),
    );
  }
}
