import 'dart:convert';

import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/InProcess_Orders/printImage.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageDisplay extends StatefulWidget {
  ImageDisplay({Key? key, this.data}) : super(key: key);
  final data;

  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  Future? futureData;
  var datas;
getImage(trackingId) async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/ups/labelrecovery/$trackingId";
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
       datas = json.decode(response.body);
      return datas;
    } else {
      print("Exception");
      throw Error;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  futureData=getImage(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:Column(children: [
 FutureBuilder(
      future: futureData,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return (snapshot.data as List).length != 0
                ? Column(children :[ RotatedBox(
      quarterTurns: 1,
      child: Image.memory(
        base64Decode(datas[0]["labelImage"]["graphicImage"]),
        height: MySize.size120 *10,
        width: MySize.size100 * 5,
      ),
    ),
    SizedBox(
      height: MySize.size160,

    ),
     SizedBox(
      width: MySize.size100*3,
      // height:MySize.size100*2,
       child: TextButton.icon(
         onPressed: () {
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (_) => PrintImage(data:datas[0]["labelImage"]["graphicImage"]),
             ),
           );
         },
         icon: Icon(Icons.print),
         label: Text('Print'),
         style: TextButton.styleFrom(
             primary: Colors.white, backgroundColor: Colors.green),
       ),
     ),
    
       ] )
                : Center(
                    child: Image.asset(
                      "assets/images/no_data_found.jpg",
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
    )
      ],)
    );
  }
}