class AddressModel {
  String name, phoneNumber, city, gavernorate, completeAddress;
  double lat, lng;

  AddressModel({
    required this.name,
    required this.phoneNumber,
    required this.city,
    required this.gavernorate,
    required this.completeAddress,
    required this.lat,
    required this.lng,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      city: json["city"],
      gavernorate: json["gavernorate"],
      completeAddress: json["completeAddress"],
      lat: json["lat"],
      lng: json["lng"],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["name"] = name;
    data["phoneNumber"] = phoneNumber;
    data["city"] = city;
    data["gavernorate"] = gavernorate;
    data["completeAddress"] = completeAddress;
    data["lat"] = lat;
    data["lng"] = lng;
    return data;
  }
}
