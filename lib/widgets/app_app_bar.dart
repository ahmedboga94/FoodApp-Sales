import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppAppBar({super.key, required this.title});
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
          colors: [
            Colors.cyan,
            Colors.amber,
          ],
        ))),
        title: Text(title,
            style: const TextStyle(fontFamily: "Signatra", fontSize: 40)),
        centerTitle: true);
  }
}
