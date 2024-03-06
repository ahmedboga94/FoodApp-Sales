class SellerModel {
  String sellerName;
  String sellerEmail;
  String sellerPhone;
  String sellerUID;
  String sellerPhotoURL;
  String sellerAddress;
  double latitude;
  double longitude;
  num earning;
  String status;

  SellerModel(
      {required this.status,
      required this.sellerName,
      required this.sellerEmail,
      required this.sellerPhone,
      required this.sellerUID,
      required this.sellerPhotoURL,
      required this.sellerAddress,
      required this.latitude,
      required this.longitude,
      required this.earning});
  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      sellerName: json["sellerName"],
      sellerEmail: json["sellerEmail"],
      sellerPhone: json["sellerPhone"],
      sellerUID: json["sellerUID"],
      sellerPhotoURL: json["sellerPhotoURL"],
      sellerAddress: json["sellerAddress"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      earning: json["earning"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["sellerName"] = sellerName;
    data["sellerEmail"] = sellerEmail;
    data["sellerPhone"] = sellerPhone;
    data["sellerUID"] = sellerUID;
    data["sellerPhotoURL"] = sellerPhotoURL;
    data["sellerAddress"] = sellerAddress;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["earning"] = earning;
    data["status"] = status;
    return data;
  }
}
