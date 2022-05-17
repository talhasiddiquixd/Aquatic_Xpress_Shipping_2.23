class PackageDimensions {
  String? title;
  double? length;
  double? width;
  double? height;
  double? weight;
  PackageDimensions({
    this.title,
    this.length,
    this.width,
    this.height,
    this.weight,
  });
}

class ShippingModel {
  String? id;
  String? organization;
  String? name;
  String? address;
  String? apart;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  String? phone;
  String? email;
  ShippingModel({
    this.id,
    this.organization,
    this.name,
    this.address,
    this.apart,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.phone,
    this.email,
  });
}

class User {
  String? name;
  String? userName;
  double? balance;
  User({
    this.name,
    this.userName,
    this.balance,
  });
}
