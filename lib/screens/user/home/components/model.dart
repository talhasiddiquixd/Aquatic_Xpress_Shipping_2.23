// // import 'dart:convert';

// // Map<String, double> albumFromJson(String str) => Map.from(json.decode(str))
// //     .map((k, v) => MapEntry<String, double>(k, v.toDouble()));

// // String albumToJson(Map<String, double> data) =>
// //     json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)));

// class Album {
//   final int id;
//   final String organization;
//   final String email;
//   final dynamic firstName;
//   final String lastName;
//   final String address;
//   final String place;
//   final String city;
//   final String state;
//   final String zipCode;
//   final String phoneNumber;
//   final bool isItResidential;
//   final bool visible;
//   final bool isActive;
//   final String userId;
//   final dynamic user;

//   const Album({
//     required this.id,
//     required this.organization,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.address,
//     required this.place,
//     required this.city,
//     required this.state,
//     required this.zipCode,
//     required this.phoneNumber,
//     required this.isItResidential,
//     required this.visible,
//     required this.isActive,
//     required this.userId,
//     required this.user,
//   });

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       id: json["id"],
//       organization: json["organization"],
//       email: json["email"],
//       firstName: json["firstName"],
//       lastName: json["lastName"],
//       address: json["address"],
//       place: json["place"],
//       city: json["city"],
//       state: json["state"],
//       zipCode: json["zipCode"],
//       phoneNumber: json["phoneNumber"],
//       isItResidential: json["isItResidential"],
//       visible: json["visible"],
//       isActive: json["isActive"],
//       userId: json["userId"],
//       user: json["user"],
//     );
//   }
// }

// To parse this JSON data, do
//
//     final album = albumFromJson(jsonString);

class Album {
  Album({
    this.todayCount,
    this.weekCount,
    this.monthCount,
    this.yearCount,
    this.todaySum,
    this.weekSum,
    this.monthSum,
    this.yearSum,
    this.todayAverage,
    this.weekAverage,
    this.monthAverage,
    this.yearAverage,
  });

  int? todayCount;
  int? weekCount;
  int? monthCount;
  int? yearCount;
  int? todaySum;
  double? weekSum;
  int? monthSum;
  double? yearSum;
  int? todayAverage;
  double? weekAverage;
  int? monthAverage;
  double? yearAverage;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        todayCount: json["todayCount"],
        weekCount: json["weekCount"],
        monthCount: json["monthCount"],
        yearCount: json["yearCount"],
        todaySum: json["todaySum"],
        weekSum: json["weekSum"].toDouble(),
        monthSum: json["monthSum"],
        yearSum: json["yearSum"].toDouble(),
        todayAverage: json["todayAverage"],
        weekAverage: json["weekAverage"].toDouble(),
        monthAverage: json["monthAverage"],
        yearAverage: json["yearAverage"].toDouble(),
      );
}
