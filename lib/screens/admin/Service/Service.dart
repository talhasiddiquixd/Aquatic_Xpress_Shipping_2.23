import 'dart:ui';

import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/screens/admin/Service/History.dart';
import 'package:aquatic_xpress_shipping/screens/admin/Service/ServiceUpcharge.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';


class Serive extends StatefulWidget {
  @override
  _SeriveState createState() => _SeriveState();
}

class _SeriveState extends State<Serive> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late TabController _tabController;
  FilePickerResult? result;


  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    _tabController.animation!.addListener(() {
      final aniValue = _tabController.animation!.value;
      if (aniValue - _currentIndex > 0.5) {
        setState(() {
          _currentIndex = _currentIndex + 1;
        });
      } else if (aniValue - _currentIndex < -0.5) {
        setState(() {
          _currentIndex = _currentIndex - 1;
        });
      }
    });
    super.initState();
  }

  onTapped(value) {
    setState(() {
      _currentIndex = value;
    });
  }

  dispose() {
    super.dispose();
    _tabController.dispose();
  }

  late ThemeData themeData;

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: <Widget>[
              Upcharge(),
              History(),
              // ActiveOrders(),
              //HistoryOrders(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: Spacing.all(16),
              child: PhysicalModel(
                color: themeData.backgroundColor,
                elevation: 12,
                borderRadius: Shape.circular(8),
                shadowColor: themeData.backgroundColor.withAlpha(140),
                shape: BoxShape.rectangle,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.backgroundColor,
                    borderRadius: Shape.circular(16),
                  ),
                  padding: Spacing.vertical(12),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: themeData.backgroundColor,
                    tabs: <Widget>[
                      Container(
                        child: (_currentIndex == 0)
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "Service Upcharge",
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        color: const Color(0xff10bb6b),
                                        letterSpacing: 0,
                                        fontWeight: 600),
                                  ),
                                  Container(
                                    margin: Spacing.top(6),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff10bb6b),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.5))),
                                    height: 5,
                                    width: 5,
                                  )
                                ],
                              )
                            : Icon(
                                Icons.running_with_errors,
                                size: MySize.size20,
                                color: themeData.colorScheme.onBackground,
                              ),
                      ),
                      Container(
                          child: (_currentIndex == 1)
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Service History",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.bodyText2,
                                          color: const Color(0xff10bb6b),
                                          letterSpacing: 0,
                                          fontWeight: 600),
                                    ),
                                    Container(
                                      margin: Spacing.top(6),
                                      decoration: BoxDecoration(
                                          color: const Color(0xff10bb6b),
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(2.5))),
                                      height: 5,
                                      width: 5,
                                    )
                                  ],
                                )
                              : Icon(
                                  Icons.history,
                                  size: MySize.size20,
                                  color: themeData.colorScheme.onBackground,
                                )),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? Padding(
              padding: EdgeInsets.only(
                bottom: MySize.size20,
                left: MySize.size60,
              ),
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                child: Icon(Icons.add),
                onPressed: () {
  
    _shippingBottomSheet(context);
  
                  // _shippingBottomSheet(
                  //   context,
                  //   false,
                  //   "",
                  //   "",
                  //   "",
                  //   "",
                  //   "",
                  // );
                },
              ),
            )
          : Container(),
    );
  }


   void _shippingBottomSheet(
    
    context,
  ) {
    //TextEditingController nameController = TextEditingController();
    TextEditingController fileController = TextEditingController();
    // TextEditingController fedexController = TextEditingController();

    // upsController.text = item;
    // fedexController.text = price;
    showModalBottomSheet(
        isScrollControlled: true,
          backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter modalsetState /*You can rename this!*/) {
            return Container(
              child: SingleChildScrollView(
                child: Container(
                    // margin: EdgeInsets.only(top: 5),
                    //height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: Padding(
                        padding: EdgeInsets.only(
                          top: 1,
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
                                Text(""),
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
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                 Row(children: [
                                   ElevatedButton(onPressed: ()
                                     async {
                result = await FilePicker.platform.pickFiles();
                if(result==null)
                {
                  print(null);
                }
                else{
                  fileController.text=result!.files[0].name.toString();
                }
                                   }, child: Icon(Icons.file_present_sharp)),
                                 SizedBox(width:MySize.size20),
                                    Padding(
                                      padding:  EdgeInsets.only(top:MySize.size20),
                                      child: SizedBox(
                                        height: MySize.size80,
                                        width:MySize.size120*2,
                                        child: customTextField(
                                        fileController,
                                        "",
                                        "File Name",
                                  ),
                                      ),
                                    ),
                                 ],
                                 
                                 ),

                                                                

                                  SizedBox(width: 10),
                                  //customTextField(
                                  // Divider(),

                                  //),
                                  // customTextField(
                                  //   nameController,
                                  //   "",
                                  //   "Name",
                                  // ),

                                 

                                  // customTextField(
                                  //   stockController,
                                  //   "",
                                  //   "Stock",
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      
                                      SizedBox(width: MySize.size10),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            String? token = await getToken();
                                            var headers = {
  'Authorization': 'Bearer $token'
};
var request = http.MultipartRequest('POST', Uri.parse("${getCloudUrl()}/api/Credit/csvparse"));
request.files.add(await http.MultipartFile.fromPath('', result!.files[0].path.toString() ));
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
  Flushbar(
        title: "Success ",
        message: "CSV file uploaded",
        duration: Duration(seconds: 3),
      )..show(context);
Navigator.pop(context);
}
else {
  Flushbar(
        title: "UnSuccessful ",
        message: "upload Failed",
        duration: Duration(seconds: 3),
      )..show(context);
  print(response.reasonPhrase);
}

                                          },
                                          child: Text("Upload"),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ))),
              ),
            );
          });
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
          readOnly: true,
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

}
