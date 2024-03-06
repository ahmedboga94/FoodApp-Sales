import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappsales/mainscreen/home_screen.dart';
import 'package:foodappsales/model/address_model.dart';
import 'package:foodappsales/model/order_model.dart';
import 'package:foodappsales/widgets/app_app_bar.dart';
import 'package:foodappsales/widgets/custom_button.dart';
import 'package:foodappsales/widgets/status_banner.dart';
import 'package:intl/intl.dart';

class OrderScreenDetails extends StatefulWidget {
  final String orderID;
  const OrderScreenDetails({super.key, required this.orderID});

  @override
  State<OrderScreenDetails> createState() => _OrderScreenDetailsState();
}

class _OrderScreenDetailsState extends State<OrderScreenDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "Order Details"),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final orderModel = OrderModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    StatusBanner(
                        status: orderModel.isSuccess,
                        orderStatus: orderModel.status),
                    Text("${orderModel.totalAmount} \$",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 22),
                    TableDetails(orderModel: orderModel),
                    const Divider(thickness: 4),
                    orderModel.status == "ended"
                        ? SizedBox(
                            height: 220,
                            child: Image.asset("assets/images/delivered.jpg"))
                        : SizedBox(
                            height: 220,
                            child: Image.asset("assets/images/packing.png")),
                    const Divider(thickness: 4),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(orderModel.orderBy)
                            .collection("addresses")
                            .doc(orderModel.addressID)
                            .get(),
                        builder: (context, addressSnapshot) {
                          if (!addressSnapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            final addressModel = AddressModel.fromJson(
                                addressSnapshot.data!.data()
                                    as Map<String, dynamic>);
                            return Column(
                              children: [
                                const Text("Shipment Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                const SizedBox(height: 10),
                                AddressTable(addressModel: addressModel),
                                const SizedBox(height: 10),
                                Text(
                                    "More Details: ${addressModel.completeAddress}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 25),
                                CustomButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            HomeScreen.id, (route) => false),
                                    text: orderModel.status == "ended"
                                        ? "Go to Home"
                                        : "Order Packing - Done",
                                    color: Colors.cyan),
                              ],
                            );
                          }
                        }),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class AddressTable extends StatelessWidget {
  const AddressTable({
    super.key,
    required this.addressModel,
  });

  final AddressModel addressModel;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FractionColumnWidth(0.35),
        1: FractionColumnWidth(0.50),
      },
      children: [
        TableRow(children: [
          const Padding(
            padding: EdgeInsets.all(3),
            child: Center(
                child: Text("Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
                child: Text(addressModel.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
        ]),
        TableRow(children: [
          const Padding(
            padding: EdgeInsets.all(3),
            child: Center(
                child: Text("Governorate",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
                child: Text(addressModel.gavernorate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
        ]),
        TableRow(children: [
          const Padding(
            padding: EdgeInsets.all(3),
            child: Center(
                child: Text("City",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
                child: Text(addressModel.city,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
        ]),
        TableRow(children: [
          const Padding(
            padding: EdgeInsets.all(3),
            child: Center(
                child: Text("Phone Number",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
                child: Text(addressModel.phoneNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
        ]),
      ],
    );
  }
}

class TableDetails extends StatelessWidget {
  const TableDetails({
    super.key,
    required this.orderModel,
  });

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FractionColumnWidth(0.25),
        1: FractionColumnWidth(0.55),
      },
      children: [
        TableRow(children: [
          const Padding(
            padding: EdgeInsets.all(3),
            child: Center(
                child: Text("ordered ID:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
                child: Text(orderModel.orderID,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
        ]),
        TableRow(children: [
          const Padding(
            padding: EdgeInsets.all(3),
            child: Center(
                child: Text("ordered at:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
                child: Text(
                    DateFormat("dd MMMM, yyy - hh:mm aa").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(orderModel.orderID))),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
        ]),
      ],
    );
  }
}
