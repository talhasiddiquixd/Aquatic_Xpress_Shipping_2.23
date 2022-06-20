import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';

import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/screens/user/profile/components/box_preferences/components/listview.dart';

import '../../../../../../AppTheme.dart';
import '../../../../../../size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future? futureUserList;
  late ThemeData themeData;

  @override
  void initState() {
    super.initState();
    futureUserList = getBoxes();
  }
var data;
  getBoxes() async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/BoxPref";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

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
       data = json.decode(response.body);
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return FutureBuilder(
      future: futureUserList,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // return BoxListView(data: snapshot.data);
            return Container(
      // height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.symmetric(horizontal: MySize.size40),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: MySize.size16,
              vertical: MySize.size4,
            ),
            child: Card(
              elevation: 15,
              clipBehavior: Clip.antiAlias,
              child: ListTileTheme(
                contentPadding: EdgeInsets.fromLTRB(MySize.size20, 0, 0, 0),
                child: ExpansionTile(
                  trailing: SizedBox.shrink(),
                  // trailing: Text(''),
                  title: Text(
                    data[index]["name"].toString(),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Length: "),
                          Text(
                            data[index]["length"].toString(),
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
                            data[index]["width"].toString(),
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
                            data[index]["height"].toString(),
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
                          MySize.size10, 0, MySize.size36, MySize.size10),
                      child: Column(children: [
                        Wrap(
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
                                _bottomSheet(
                                  context,
                                  true,
                                  data[index]["name"].toString(),
                                  data[index]["length"].toString(),
                                  data[index]["width"].toString(),
                                  data[index]["height"].toString(),
                                );
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
                                deleteBox(data[index]["id"].toString());
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
          return listViewWithoutLeadingPictureWithoutExpandedSkeleton(context);
        }
      },
    );
  }
   TextEditingController nameController = TextEditingController(),
      heightController = TextEditingController(),
      widthController = TextEditingController(),
      lengthController = TextEditingController(),
      stockController = TextEditingController();

  void _bottomSheet(
    context,
    bool edit,
    String height,
    String width,
    String length,
    String weight,
  ) {
    nameController.text = height;
    heightController.text = width;
    widthController.text = length;
    lengthController.text = weight;
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
                          edit ? "Edit Box" : "Add Box",
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
                          nameController,
                          "",
                          "Name",
                        ),
                        customTextField(
                          heightController,
                          "",
                          "Height",
                        ),
                        customTextField(
                          widthController,
                          "",
                          "Width",
                        ),
                        customTextField(
                          lengthController,
                          "",
                          "Length",
                        ),
                        edit
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      // width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Save Changes"),
                                  )),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      // width: MediaQuery.of(context).size.width,
                                      child: Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Add Product"),
                                      ),
                                    ],
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
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 7,
        )
      ],
    );
  }

  deleteBox(id) async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/BoxPref/" +
        id.toString();
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

    var url = Uri.parse(link);
    var response = await http.post(
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

}
