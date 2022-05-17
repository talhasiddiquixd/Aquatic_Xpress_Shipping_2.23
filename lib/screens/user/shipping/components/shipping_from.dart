// import 'package:flutter/material.dart';

// class ShippingFrom extends StatefulWidget {
//   const ShippingFrom({Key? key}) : super(key: key);

//   @override
//   _ShippingFromState createState() => _ShippingFromState();
// }

// class _ShippingFromState extends State<ShippingFrom> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),body: SingleChildScrollView(
//             child: Container(
//               margin: EdgeInsets.only(top: MySize.size60),
//               height: MediaQuery.of(context).size.height,
//               decoration: BoxDecoration(
//                   color: themeData.backgroundColor,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(MySize.size16),
//                       topRight: Radius.circular(MySize.size16))),
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   top: MySize.size10,
//                   left: MySize.size10,
//                   right: MySize.size10,
//                   // bottom: 300,
//                 ),
//                 child: Column(
//                   // mainAxisSize: MainAxisSize.min,
//                   // mainAxisAlignment: ,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           shipping == "from" ? "Shipping from" : "Shipping to",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: MySize.size20),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: Icon(
//                             Icons.close,
//                             color: Colors.black,
//                           ),
//                         )
//                       ],
//                     ),
//                     Divider(thickness: 1),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {},
//                           child: Text("Add Address"),
//                           style: ButtonStyle(
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(MySize.size18),
//                               ),
//                             ),
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             modalSetState(() {
//                               _shippingAddressBottomSheet(context, shipping);
//                             });
//                           },
//                           child: Text("Saved Address"),
//                           style: ButtonStyle(
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(MySize.size18),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         customTextField(
//                             shipping == "from"
//                                 ? fOrgController
//                                 : tOrgController,
//                             "",
//                             "Organization"),
//                         customTextField(
//                             shipping == "from"
//                                 ? fNameController
//                                 : tNameController,
//                             "",
//                             "Name"),
//                         customTextField(
//                             shipping == "from"
//                                 ? fAddressController
//                                 : tAddressController,
//                             "",
//                             "Address"),
//                         customTextField(
//                             shipping == "from"
//                                 ? fApartController
//                                 : tApartController,
//                             "",
//                             "Apart/Building"),
//                         customTextField(
//                             shipping == "from"
//                                 ? fCityController
//                                 : tCityController,
//                             "",
//                             "City"),
//                         customTextField(
//                             shipping == "from"
//                                 ? fStateController
//                                 : tStateController,
//                             "Short name i.e DC, NY, FL",
//                             "State"),
//                         customTextField(
//                           shipping == "from" ? fZipController : tZipController,
//                           "",
//                           "Zip Code",
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Text('New Address?'),
//                                 Switch(
//                                   onChanged: (bool value) {
//                                     modalSetState(() {
//                                       fromNewAddress = value;
//                                     });
//                                   },
//                                   value: fromNewAddress,
//                                   // activeColor: Colors.blue,
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Text('Residential?'),
//                                 Container(
//                                   child: Switch(
//                                       onChanged: (bool value) {
//                                         modalSetState(() {
//                                           residential = value;
//                                         });
//                                       },
//                                       value: residential
//                                       // activeColor: Colors.blue,
//                                       ),
//                                 ),
//                               ],
//                             ),

//                             // ElevatedButton(
//                             //   onPressed: () {},
//                             //   child: Text("Get Weather"),
//                             //   style: ButtonStyle(
//                             //     shape: MaterialStateProperty.all<
//                             //         RoundedRectangleBorder>(
//                             //       RoundedRectangleBorder(
//                             //         borderRadius: BorderRadius.circular(18.0),
//                             //       ),
//                             //     ),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                         customTextField(
//                           shipping == "from"
//                               ? fPhoneController
//                               : tPhoneController,
//                           "",
//                           "Phone",
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           child: ElevatedButton(
//                               onPressed: () {
//                                 if (shipping == "from") {
//                                   from.organization = fOrgController.text;
//                                   from.name = fNameController.text;
//                                   from.address = fAddressController.text;
//                                   from.apart = fApartController.text;
//                                   from.city = fCityController.text;
//                                   from.zipCode = fZipController.text;
//                                   from.state = fStateController.text;
//                                   from.phone = fPhoneController.text;
//                                 } else {
//                                   to.organization = tOrgController.text;
//                                   to.name = tNameController.text;
//                                   to.address = tAddressController.text;
//                                   to.apart = tApartController.text;
//                                   to.city = tCityController.text;
//                                   to.zipCode = tZipController.text;
//                                   to.state = tStateController.text;

//                                   to.phone = tPhoneController.text;
//                                 }
//                                 setState(() {});

//                                 Navigator.pop(context);
//                               },
//                               child: Text("Save")),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         ,
//     );
//   }
// }
