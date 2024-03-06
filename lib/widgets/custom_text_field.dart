import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData iconData;
  final String hintText;
  final bool isObsecure;
  final bool enable;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.iconData,
    required this.hintText,
    this.isObsecure = false,
    this.enable = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        controller: controller,
        enabled: enable,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(iconData, color: Colors.cyan),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText),
      ),
    );
  }
}
