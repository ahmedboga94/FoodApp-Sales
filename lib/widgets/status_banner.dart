import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
  final bool status;
  final String orderStatus;
  const StatusBanner(
      {super.key, required this.status, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    String message;

    status ? message = "Successful" : message = "Unsuccessful";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 20),
        Text(
          orderStatus == "ended"
              ? "Parcel Delivered $message"
              : "Order Placed $message",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 10,
          backgroundColor: status ? Colors.green : Colors.grey,
          child: Center(
            child: Icon(
              status ? Icons.done : Icons.cancel,
              color: Colors.white,
              size: 20,
            ),
          ),
        )
      ],
    );
  }
}
