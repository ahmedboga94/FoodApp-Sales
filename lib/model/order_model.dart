import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String addressID,
      orderBy,
      paymentDetails,
      sellerUID,
      orderID,
      driverID,
      status;
  final bool isSuccess;
  final List productsIDs;
  final num totalAmount;
  final Timestamp orderTime;

  OrderModel({
    required this.addressID,
    required this.productsIDs,
    required this.orderTime,
    required this.orderBy,
    required this.paymentDetails,
    required this.totalAmount,
    required this.orderID,
    required this.driverID,
    required this.sellerUID,
    required this.isSuccess,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      addressID: json["addressID"],
      orderTime: json["orderTime"],
      productsIDs: json["productsIDs"],
      driverID: json["driverID"],
      sellerUID: json["sellerUID"],
      orderID: json["orderID"],
      orderBy: json["orderBy"],
      paymentDetails: json["paymentDetails"],
      totalAmount: json["totalAmount"],
      isSuccess: json["isSuccess"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["addressID"] = addressID;
    data["orderTime"] = orderTime;
    data["productsIDs"] = productsIDs;
    data["driverID"] = driverID;
    data["sellerUID"] = sellerUID;
    data["orderID"] = orderID;
    data["orderBy"] = orderBy;
    data["paymentDetails"] = paymentDetails;
    data["totalAmount"] = totalAmount;
    data["isSuccess"] = isSuccess;
    data["status"] = status;
    return data;
  }
}
