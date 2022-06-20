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
      jsonData.clear();
       data1 = json.decode(response.body);
        jsonData.addAll(data1);
      searchJson.addAll(data1);
      return data1;
    } else {
      print("Exception");
      throw Error;
    }
  }

  deleteBox(id) async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/BoxPref/Delete/$id";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
      // body: jsonEncode(
      //   {
      //     'id': id.toString(),
      //   },
      // ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      futureUserList=getBoxes();
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
          "userId":id.toString(),
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      futureUserList = getBoxes();
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
    // code,
    userId
  ) async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/BoxPref/EditBox";
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
          "id": id,
          "name": name,
          "length": length,
          "width": width,
          "height": height,
          // "code": code,
          "userId":id.toString(),
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      jsonData.clear();
      futureUserList=getBoxes();
      setState(() {
        
      });
      // var data = json.decode(response.body);
      // return data;
    } else {
      print("Exception");
      throw Error;
    }
  }


List searchJson=[];
List jsonData=[];
String ?_chosenValue="ASC";
String? chosenFieldValue;
 TextEditingController txtQuery = new TextEditingController();
  
  
  void search(String query) {
  if (query.isEmpty) {
    jsonData = searchJson;
    setState(() {});
    return;
  }

  query = query.toLowerCase();
  print(query);
  List result = [];
  jsonData.forEach((p) {
    var name =p["name"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
     name =p["length"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
   name =p["height"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
   name =p["width"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
  
  });

  var data = result;
 List orders=[];
orders.addAll(data);
var uniqueData = orders.map((o) => o).toSet();
 result.clear();
result.addAll(uniqueData);


  jsonData = result;
  setState(() {});
}
 
 @override
  void initState() { 
    super.initState();
    jsonData.clear();
    try {
   futureUserList = getBoxes();
            } catch (e) {
              print(e);
            }
            
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    jsonData;
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
      body: Column(
        children: [
          Padding(
          padding:  EdgeInsets.only(left: MySize.size10, top:MySize.size10, right:MySize.size10),
          child:
          TextFormField(
  controller: txtQuery,
  onChanged: search,
  decoration: InputDecoration(
  filled: true,
  fillColor: themeData.backgroundColor,
      hintText: "Search",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: themeData.primaryColor),
      borderRadius: BorderRadius.circular(15.0),
      ),
      prefixIcon: Icon(Icons.search),
      suffixIcon: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          txtQuery.text = '';
          search(txtQuery.text);
        },
      ),
  ),
),
    
              ),

        Padding(
  padding:  EdgeInsets.only(left:MySize.size40),
  child:   Row(
  
    children: [
  
          DropdownButton<String>(
  
      
  
          focusColor:Colors.white,
  
      
  
      dropdownColor:themeData.backgroundColor,
  
      
  
                  value: _chosenValue,
  
      
  
                  //elevation: 5,
  
      
  
                  style: TextStyle(color: Colors.black),
  
      
  
      
  
      
  
                  items: <String>[
  
      
  
                    'ASC',
  
      
  
                    'DES',
  
      
  
                  ].map<DropdownMenuItem<String>>((String value) {
  
      
  
                    return DropdownMenuItem<String>(
  
      
  
                      value: value,
  
      
  
                      child: Text(value),
  
      
  
                    );
  
      
  
                  }).toList(),
  
      
  
                  hint: Text(
  
      
  
                    "Sort",
  
      
  
                    style: TextStyle(
  
      
  
                        color: Colors.black,
  
      
  
                        fontSize: 16,
  
      
  
                        fontWeight: FontWeight.w600),
  
      
  
                  ),
  
      
  
                  onChanged: (String ?value) {
  
      
  
                    setState(() {
  
      
  
                      _chosenValue = value;
  
      
  
                    });
  
      
  
                  }),
  
  
  
                  Padding(
                    padding: EdgeInsets.only(left:MySize.size20),
                    child: DropdownButton<String>(
  
      focusColor:Colors.white,
  
  dropdownColor:themeData.backgroundColor,
  
              value: chosenFieldValue,
  
              //elevation: 5,
  
              style: TextStyle(color: Colors.black),
  
  
  
              items: <String>[
  
                'Name',
                'Length',
                'Height',
                'Width',
              ].map<DropdownMenuItem<String>>((String value) {
  
                return DropdownMenuItem<String>(
  
                    value: value,
  
                    child: Text(value),
  
                );
  
              }).toList(),
  
              hint: Text(
  
                "Choose field to Sort",
  
                style: TextStyle(
  
                      color: Colors.black,
  
                      fontSize: 16,
  
                      fontWeight: FontWeight.w600),
  
              ),
  
              onChanged: (String ?value) {
  
                setState(() {
  
                    chosenFieldValue = value;
  
                });
  
              }),
                  ),
  
  

               Padding(
  padding:  EdgeInsets.only(left:MySize.size10),
  child:   GestureDetector(
    onTap: (){
      if(_chosenValue=="ASC" )
{
  if(chosenFieldValue=="Name")
  {
jsonData.sort((a, b) => a["name"].compareTo(b["name"]));
setState(() {
  
});
  }
  else if(chosenFieldValue=="Length")
  {
    jsonData.sort((a, b) => a["length"].compareTo(b["length"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Height")
  {
    jsonData.sort((a, b) => a["height"].compareTo(b["height"]));
    setState(() {
  
});}
  else if(chosenFieldValue=="Width")
  {
jsonData.sort((a, b) => a["width"].compareTo(b["width"]));
    setState(() {
  
});

  }
  
  
}
else if(_chosenValue=="DES")
{
   if(chosenFieldValue=="Name")
  {
jsonData.sort((a, b) => b["name"].compareTo(a["name"]));
setState(() {
  
});
  }
  else if(chosenFieldValue=="Height")
  {
    jsonData.sort((a, b) => b["height"].compareTo(a["height"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Length")
  {
    jsonData.sort((a, b) => b["lenght"].compareTo(a["length"]));
    setState(() {
  
});}
  else if(chosenFieldValue=="Width")
  {
jsonData.sort((a, b) => b["width"].compareTo(a["width"]));
    setState(() {
  
});

  }
 
}
    },
    child: Container(
    
                         width:MySize.size60,
    
                         height: MySize.size40,
    
       decoration: BoxDecoration(
    
        color: Colors.grey[400],
    
       borderRadius: BorderRadius.all(Radius.circular(4)
    
      
    
       )
    
       
    
     ),
    
     child: Center(child: Text("Sort"))
    
    ),
  ),
)  
    
    
    
    
    ],
  
  ),
),
          

          Expanded(
            child: FutureBuilder(
              future: futureUserList,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      // height: MediaQuery.of(context).size.height * 0.8,
                      padding: EdgeInsets.only(bottom: MySize.size40),
                      child: ListView.builder(
                        itemCount:jsonData.length,
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
                                       jsonData[index]["name"]
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
                                               jsonData[index]
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
                                               jsonData[index]
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
                                               jsonData[index]
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
                                                     jsonData[index],
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
          ),
        ],
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
                                  // box['code'],
                                  jsonData[0]["userId"].toString()
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
                            data1[0]["userId"].toString()
                                                  
                          );
                                getBoxes();

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
