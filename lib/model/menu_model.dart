import 'package:cloud_firestore/cloud_firestore.dart';

class MenuModel {
  String menuID, menuImageURL, menuInfo, menuTitle, sellerUID, status;
  Timestamp publishedData;

  MenuModel({
    required this.menuID,
    required this.sellerUID,
    required this.menuImageURL,
    required this.menuTitle,
    required this.menuInfo,
    required this.publishedData,
    required this.status,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      menuID: json["menuID"],
      sellerUID: json["sellerUID"],
      menuImageURL: json["menuImageURL"],
      menuTitle: json["menuTitle"],
      menuInfo: json["menuInfo"],
      publishedData: json["publishedData"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["menuID"] = menuID;
    data["sellerUID"] = sellerUID;
    data["menuImageURL"] = menuImageURL;
    data["menuTitle"] = menuTitle;
    data["menuInfo"] = menuInfo;
    data["publishedData"] = publishedData;
    data["status"] = status;

    return data;
  }
}
