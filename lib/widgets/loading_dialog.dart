import 'package:flutter/material.dart';
import 'package:foodappsales/widgets/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  final String message;
  const LoadingDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgress(),
          const SizedBox(height: 10),
          Text("$message,\nPlease Wait ...")
        ],
      ),
    );
  }
}
