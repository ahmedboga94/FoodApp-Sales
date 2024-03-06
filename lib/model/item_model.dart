import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String itemID,
      menuID,
      sellerUID,
      sellerName,
      itemImageURL,
      itemTitle,
      itemInfo,
      itemDescription,
      status;
  Timestamp publishedData;
  num itemPrice;

  ItemModel({
    required this.itemID,
    required this.menuID,
    required this.sellerUID,
    required this.sellerName,
    required this.itemImageURL,
    required this.itemTitle,
    required this.itemInfo,
    required this.itemDescription,
    required this.itemPrice,
    required this.publishedData,
    required this.status,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemID: json["itemID"],
      menuID: json["menuID"],
      sellerUID: json["sellerUID"],
      sellerName: json["sellerName"],
      itemImageURL: json["itemImageURL"],
      itemTitle: json["itemTitle"],
      itemInfo: json["itemInfo"],
      itemDescription: json["itemDescription"],
      itemPrice: json["itemPrice"],
      publishedData: json["publishedData"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["itemID"] = itemID;
    data["menuID"] = menuID;
    data["sellerUID"] = sellerUID;
    data["sellerName"] = sellerName;
    data["itemImageURL"] = itemImageURL;
    data["itemTitle"] = itemTitle;
    data["itemInfo"] = itemInfo;
    data["itemDescription"] = itemDescription;
    data["itemPrice"] = itemPrice;
    data["publishedData"] = publishedData;
    data["status"] = status;

    return data;
  }
}
