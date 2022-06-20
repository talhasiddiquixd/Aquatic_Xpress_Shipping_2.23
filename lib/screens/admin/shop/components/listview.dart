import 'dart:convert';
import 'dart:io';

import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/screens/admin/shop/components/Deals.dart';
import 'package:aquatic_xpress_shipping/screens/admin/shop/components/Edit.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:http/http.dart' as http;


class CustomListView extends StatefulWidget {
  final data;

  const CustomListView({Key? key, required this.data}) : super(key: key);

  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  List listData = [];
  deleteData(id, index) async {
    String? token = await getToken();
    var headers = {
      'Authorization': 'Bearer $token",',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request(
        'POST',
        Uri.parse('${getCloudUrl()}/api/Products/Delete/' +
            id.toString()));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      listData[0].removeAt(index);
      setState(() {});
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  late ThemeData themeData;
  File? _image;
  int selectedValue = 0;
  String? base64Image;
  @override
  void initState() {
    super.initState();
    listData.add(widget.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Container(
      // height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(bottom: MySize.size40),
      child: ListView.builder(
        itemCount: listData[0].length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    MySize.size10, MySize.size2, MySize.size10, MySize.size2),
                child: Card(
                  elevation: 15,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(MySize.size20),
                  ),
                  child: ListTileTheme(
                    // dense: true,

                    contentPadding: EdgeInsets.fromLTRB(MySize.size10, 0, 0, 0),
                    child: ExpansionTile(
                      trailing: SizedBox.shrink(),
                      // trailing: Text(''),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          base64Decode(
                            listData[0][index]["image"].toString(),
                          ),
                        ),
                      ),

                      title: Text(
                        listData[0][index]["name"].toString(),
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.bodyText1,
                          fontWeight: 550,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Price: \$"),
                              Text(
                                listData[0][index]["price"].toString(),
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 550,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Stock: "),
                              Text(
                                listData[0][index]["stock"].toString(),
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 550,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              MySize.size10, 0, MySize.size20, MySize.size10),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.black,
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.amber.shade200,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Edit(
                                                  data: listData[0][index]
                                                          ["image"]
                                                      .toString(),
                                                  name: listData[0][index]
                                                          ["name"]
                                                      .toString(),
                                                  details: listData[0][index]
                                                          ["details"]
                                                      .toString(),
                                                  price: listData[0][index]
                                                          ["price"]
                                                      .toString(),
                                                  stock: listData[0][index]
                                                          ["stock"]
                                                      .toString(),
                                                  color: listData[0][index]
                                                          ["color"]
                                                      .toString(),
                                                  id: listData[0][index]["id"]
                                                      .toString(),
                                                )));
                                  },
                                  icon: Icon(Icons.edit),
                                  label: Text("Edit"),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton.icon(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.black,
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.redAccent.shade100,
                                    ),
                                  ),
                                  onPressed: () {
                                    deleteData(
                                        listData[0][index]["id"].toString(),
                                        index);
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text("Delete"),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton.icon(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.black,
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blueAccent),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Deals(
                                                data: listData[0][index])));
                                  },
                                  icon: Icon(Icons.edit),
                                  label: Text("Deals"),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  TextEditingController nameController = TextEditingController(),
      detailController = TextEditingController(),
      priceController = TextEditingController(),
      colorController = TextEditingController(),
      stockController = TextEditingController();

  // void _shippingBottomSheet(
  //   context,
  //   bool edit,
  //   String name,
  //   String detail,
  //   String price,
  //   String color,
  //   String stock,
  //   String image,
  // ) {
  //   nameController.text = name;
  //   detailController.text = detail;
  //   priceController.text = price;
  //   colorController.text = color;
  //   stockController.text = stock;

  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (BuildContext buildContext) {
  //         return StatefulBuilder(builder: (BuildContext context,
  //             StateSetter modalsetState /*You can rename this!*/) {
  //           return Container(
  //             child: SingleChildScrollView(
  //               child: Container(
  //                 margin: EdgeInsets.only(top: 70),
  //                 height: MediaQuery.of(context).size.height,
  //                 decoration: BoxDecoration(
  //                     color: themeData.backgroundColor,
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(16),
  //                         topRight: Radius.circular(16))),
  //                 child: Padding(
  //                     padding: EdgeInsets.only(
  //                       top: 10,
  //                       left: 24,
  //                       right: 24,
  //                       // bottom: 300,
  //                     ),
  //                     child: Column(
  //                       // mainAxisSize: MainAxisSize.min,
  //                       // mainAxisAlignment: ,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               edit ? "Edit Product" : "Add Product",
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.bold, fontSize: 20),
  //                             ),
  //                             IconButton(
  //                               onPressed: () {
  //                                 Navigator.pop(context);
  //                               },
  //                               icon: Icon(
  //                                 Icons.close,
  //                                 color: Colors.black,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                         Divider(
  //                           height: 20,
  //                           thickness: 1,
  //                           // indent: 10,
  //                           // endIndent: 10,
  //                         ),
  //                         Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               customTextField(
  //                                 nameController,
  //                                 "",
  //                                 "Name",
  //                               ),
  //                               customTextField(
  //                                 detailController,
  //                                 "",
  //                                 "Detail",
  //                               ),
  //                               customTextField(
  //                                 priceController,
  //                                 "",
  //                                 "Price",
  //                               ),
  //                               customTextField(
  //                                 colorController,
  //                                 "",
  //                                 "Color",
  //                               ),
  //                               customTextField(
  //                                 stockController,
  //                                 "",
  //                                 "Stock",
  //                               ),
  //                               Padding(
  //                                 padding:
  //                                     EdgeInsets.only(right: MySize.size180),
  //                                 child: Container(
  //                                   height: 120,
  //                                   width: 230,
  //                                   child: ClipRRect(
  //                                     borderRadius:
  //                                         BorderRadius.circular(MySize.size16),
  //                                     child: selectedValue == 1
  //                                         ? Image.memory(base64Decode(
  //                                             base64Image.toString()))
  //                                         : Image.memory(base64Decode(image)),
  //                                   ),
  //                                 ),
  //                               ),
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   IconButton(
  //                                       icon: Icon(
  //                                         Icons.photo,
  //                                         color: Colors.black,
  //                                       ),
  //                                       onPressed: _takePictureFromGallery),
  //                                   IconButton(
  //                                     icon: Icon(
  //                                       Icons.camera_alt,
  //                                       color: Colors.black,
  //                                     ),
  //                                     onPressed: _takePicture,
  //                                   ),
  //                                 ],
  //                               ),
  //                             ]),
  //                         edit
  //                             ? Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Container(
  //                                       // width: MediaQuery.of(context).size.width,
  //                                       child: Row(
  //                                     children: [
  //                                       ElevatedButton(
  //                                         onPressed: () {
  //                                           selectedValue = 0;
  //                                           base64Image = " ";

  //                                           Navigator.pop(context);
  //                                         },
  //                                         child: Text("Edit Deals"),
  //                                       ),
  //                                       SizedBox(width: MySize.size10),
  //                                       ElevatedButton(
  //                                         onPressed: () {},
  //                                         child: Text("Save Changes"),
  //                                       ),
  //                                     ],
  //                                   )),
  //                                 ],
  //                               )
  //                             : Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Container(
  //                                       // width: MediaQuery.of(context).size.width,
  //                                       child: Row(
  //                                     children: [
  //                                       ElevatedButton(
  //                                         onPressed: () {
  //                                           Navigator.pop(context);
  //                                         },
  //                                         child: Text("Add Product"),
  //                                       ),
  //                                     ],
  //                                   )),
  //                                 ],
  //                               ),
  //                       ],
  //                     )),
  //               ),
  //             ),
  //           );
  //         });
  //       });
 // }

  final picker = ImagePicker();
  void takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      List<int> imageBytes = _image!.readAsBytesSync();

      base64Image = base64Encode(imageBytes);
    }
    setState(() {});
  }

  void takePictureFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        List<int> imageBytes = _image!.readAsBytesSync();

        base64Image = base64Encode(imageBytes);
        selectedValue = 1;

        print('string is');
        print(base64Image);
      } else {
        print('No image selected.');
      }
    });
  }
}

Widget customTextField(
  controller,
  hintText,
  labelText,
) {
  return Column(
    children: [
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          //  fillColor: themeData.colorScheme.background,
          hintStyle: TextStyle(
              //  color: themeData.colorScheme.onBackground,
              ),
          filled: true,
          hintText: hintText,
          labelText: labelText,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          // prefixIcon: Icon(Icons.person),
        ),
        keyboardType: TextInputType.number,
      ),
      SizedBox(
        height: 7,
      )
    ],
  );
}
