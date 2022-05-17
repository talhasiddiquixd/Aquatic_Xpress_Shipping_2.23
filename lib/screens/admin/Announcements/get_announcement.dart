import 'dart:async';

import 'package:aquatic_xpress_shipping/screens/Service/Service.dart';
import 'package:aquatic_xpress_shipping/screens/admin/Announcements/list_announce.dart';
import 'package:flutter/material.dart';

class Getannouncement extends StatefulWidget {
  const Getannouncement({Key? key}) : super(key: key);

  @override
  _GetannouncementState createState() => _GetannouncementState();
}

class _GetannouncementState extends State<Getannouncement> {
  Future? futureUserList;
  Service services = new Service();
  bool isConnected = false;
  late ThemeData themeData;

  @override
  void initState() {
    super.initState();
    futureUserList = services.getAdminAnnouncements();

  }

  

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: futureUserList,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return ListAnnounce(data: snapshot.data);
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Center(child: Text('No Data Found')),
                    );
                  }
                } else {
                  return Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
