import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/size_config.dart';

class BoxPreferences extends StatefulWidget {
  const BoxPreferences({Key? key}) : super(key: key);

  @override
  _BoxPreferencesState createState() => _BoxPreferencesState();
}

class _BoxPreferencesState extends State<BoxPreferences> {
  late ThemeData themeData;

  TextEditingController nameController = TextEditingController(),
      heightController = TextEditingController(),
      widthController = TextEditingController(),
      lengthController = TextEditingController(),
      stockController = TextEditingController();
 var data1;
  Future? futureUserList;
  getBoxes() async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/BoxPref";

    var url = Uri.parse(link);
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
       data1 = json.decode(response.body);
      return data1;
    } else {
      print("Exception");
      throw Error;
    }
  }

  deleteBox(id) async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/BoxPref/" +
        id.toString();
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

    var url = Uri.parse(link);
    var response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          'id': id.toString(),
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      print("Exception");
      throw Error;
    }
  }

  saveBox(
    name,
    length,
    width,
    height,
    id,
  ) async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/BoxPref";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          "name": nameController.text,
          "length": lengthController.text,
          "width": widthController.text,
          "height": heightController.text,
          "userId":id.toString()
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      // return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  editBox(
    id,
    name,
    length,
    width,
    height,
    code,
  ) async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/BoxPref";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

    var url = Uri.parse(link);
    var response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          "id": id,
          "name": name,
          "length": length,
          "width": width,
          "height": height,
          "code": code,
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      // return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  @override
  void initState() {
    super.initState();
    futureUserList = getBoxes();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    MySize().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Box Preferences"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: futureUserList,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Container(
                // height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.only(bottom: MySize.size40),
                child: ListView.builder(
                  itemCount: (snapshot.data as List).length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: MySize.size16,
                            vertical: MySize.size4,
                          ),
                          child: Card(
                            elevation: 15,
                            clipBehavior: Clip.antiAlias,
                            child: ListTileTheme(
                              // dense: true,

                              contentPadding:
                                  EdgeInsets.fromLTRB(MySize.size20, 0, 0, 0),
                              child: ExpansionTile(
                                trailing: SizedBox.shrink(),
                                // trailing: Text(''),
                                title: Text(
                                  (snapshot.data as List)[index]["name"]
                                      .toString(),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Length: "),
                                        Text(
                                          (snapshot.data as List)[index]
                                                  ["length"]
                                              .toString(),
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.button,
                                            fontWeight: 550,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Width: "),
                                        Text(
                                          (snapshot.data as List)[index]
                                                  ["width"]
                                              .toString(),
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.button,
                                            fontWeight: 550,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Height: "),
                                        Text(
                                          (snapshot.data as List)[index]
                                                  ["height"]
                                              .toString(),
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
                                    margin: EdgeInsets.fromLTRB(MySize.size10,
                                        0, MySize.size36, MySize.size10),
                                    child: Column(children: [
                                      Wrap(
                                        children: [
                                          ElevatedButton.icon(
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.black,
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.amber.shade200,
                                              ),
                                            ),
                                            onPressed: () {
                                              _editBottomSheet(
                                                context,
                                                (snapshot.data as List)[index],
                                              );
                                            },
                                            icon: Icon(Icons.edit),
                                            label: Text("Edit"),
                                          ),
                                          SizedBox(width: 10),
                                          ElevatedButton.icon(
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.black,
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.redAccent.shade100,
                                              ),
                                            ),
                                            onPressed: () {
                                              deleteBox((snapshot.data
                                                      as List)[index]["id"]
                                                  .toString());
                                            },
                                            icon: Icon(Icons.delete),
                                            label: Text("Delete"),
                                          )
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
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Center(
                    child: Image.asset(
                  "assets/images/no_data_found.jpg",
                )),
              );
            }
          } else {
            return listViewWithoutLeadingPictureWithoutExpandedSkeleton(
                context);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addBottomSheet(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _editBottomSheet(
    context,
    box,
  ) {
    nameController.text = box['name'];
    heightController.text = box['height'];
    widthController.text = box['width'];
    lengthController.text = box['length'];
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 70),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: themeData.backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 24,
                  right: 24,
                  // bottom: 300,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Edit Box",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      // indent: 10,
                      // endIndent: 10,
                    ),
                    Column(
                      children: [
                        customTextField(
                            nameController, "", "Name", TextInputType.text),
                        customTextField(heightController, "Inches", "Height",
                            TextInputType.number),
                        customTextField(widthController, "Inches", "Width",
                            TextInputType.number),
                        customTextField(lengthController, "Inches", "Length",
                            TextInputType.number),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                // width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                              onPressed: () {
                                editBox(
                                  box['id'],
                                  nameController.text,
                                  lengthController.text,
                                  widthController.text,
                                  heightController.text,
                                  box['code'],
                                );
                                Navigator.pop(context);
                              },
                              child: Text("Save Changes"),
                            )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _addBottomSheet(context) {
    nameController.text = "";
    heightController.text = "";
    widthController.text = "";
    lengthController.text = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext buildContext) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 70),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: themeData.backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 24,
                right: 24,
                // bottom: 300,
              ),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: ,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Added Box",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {
                         
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 1,
                    // indent: 10,
                    // endIndent: 10,
                  ),
                  Column(
                    children: [
                      customTextField(
                          nameController, "", "Name", TextInputType.text),
                      customTextField(heightController, "Inches", "Height",
                          TextInputType.number),
                      customTextField(widthController, "Inches", "Width",
                          TextInputType.number),
                      customTextField(lengthController, "Inches", "Length",
                          TextInputType.number),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {
                                saveBox(
                            nameController.text,
                            lengthController.text,
                            widthController.text,
                            heightController.text,
                            data1[1]["userId"].toString()
                                                  
                          );
                                Navigator.pop(context);
                              },
                              child: Text("Add Box"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget customTextField(
    controller,
    hintText,
    labelText,
    keyboard,
  ) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            fillColor: themeData.colorScheme.background,
            hintStyle: TextStyle(
              color: themeData.colorScheme.onBackground,
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
          keyboardType: keyboard,
        ),
        SizedBox(
          height: 7,
        )
      ],
    );
  }
}
