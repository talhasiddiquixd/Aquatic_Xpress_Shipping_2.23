import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Announcements extends StatefulWidget {
  final data;
  const Announcements({Key? key, this.data}) : super(key: key);

  @override
  AannouncemenstState createState() => AannouncemenstState();
}

class AannouncemenstState extends State<Announcements> {
  var timeToPost;
  postData() async {
    var myDate;
    String? token = await getToken();
    if (timeToPost == null) {
      timeToPost = _timeController.text.split(" ")[0];
      myDate = _dateController.text + 'T' + timeToPost + ":00";
    } else {
      myDate = _dateController.text + 'T' + timeToPost + ":00";
    }
    String ?link =
        "${getCloudUrl()}/api/Auth/saveAnnouncement";
    var url = Uri.parse(link);
    var response = await http.post(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "dateTime": myDate,
          "subject": subjectController.text,
          "discription": discriptionController.text,
        }));

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Flushbar(
        title: "Success",
        message: "Data Added Successfully",
        duration: Duration(seconds: 3),
      )..show(context);
      print(response.statusCode);
    } else {
      Flushbar(
        title: "Failed",
        message: "Data not Added!",
        duration: Duration(seconds: 3),
      )..show(context);
      print("Exception");
      throw Error;
    }
  }

  postUpdateData() async {
    var myDate;
    String? token = await getToken();
    if (timeToPost == null) {
      timeToPost = _timeController.text.split(" ")[0];
      myDate = _dateController.text + 'T' + timeToPost + ":00";
    } else {
      myDate = _dateController.text + 'T' + timeToPost + ":00";
    }
    String ?link =
        "${getCloudUrl()}/api/Auth/UpdateAnnouncement";
    var url = Uri.parse(link);
    var response = await http.post(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "id": widget.data["id"].toString(),
          "dateTime": myDate,
          "subject": subjectController.text,
          "discription": discriptionController.text,
        }));

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Flushbar(
        title: "Success",
        message: "Data Updated Successfully",
        duration: Duration(seconds: 3),
      )..show(context);
      print(response.statusCode);
    } else {
      Flushbar(
        title: "Failed",
        message: "Data not Updated!",
        duration: Duration(seconds: 3),
      )..show(context);
      print("Exception");
      throw Error;
    }
  }




  String? _hour, _minute, _time;

  String? dateTime;
  late ThemeData themeData;
  DateTime selectedDate = DateTime.now();

  // TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.data == null
            ? selectedDate
            : DateTime.parse(widget.data["dateTime"]),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        print(picked);
        _dateController.text = DateFormat("yyyy-MM-dd").format((selectedDate));
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.data == null
          ? selectedTime
          : TimeOfDay.fromDateTime(DateTime.parse(widget.data["dateTime"])),
    );
    if (picked != null) print(picked);
    setState(() {
      selectedTime = picked!;
      _hour = selectedTime.hour.toString();
      _minute = selectedTime.minute.toString();
      _time = _hour! + ' : ' + _minute!;
      timeToPost = _hour! + ':' + _minute!;
      _timeController.text = _time!;
      _timeController.text = formatDate(
          DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
          [hh, ':', nn, " ", am]).toString();
      timeToPost = formatDate(
          DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute), [
        hh,
        ':',
        nn,
      ]).toString();
    });
  }

  @override
  void initState() {
    if (widget.data == null) {
      _dateController.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
      print(selectedDate);
      _timeController.text = formatDate(
          DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
          [hh, ':', nn, " ", am]).toString();
    } else {
      _dateController.text = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(widget.data["dateTime"]));
      print(selectedDate);
      _timeController.text = formatDate(
          DateTime(
              2019,
              08,
              1,
              TimeOfDay.fromDateTime(DateTime.parse(widget.data["dateTime"]))
                  .hour,
              TimeOfDay.fromDateTime(DateTime.parse(widget.data["dateTime"]))
                  .minute),
          [hh, ':', nn, " ", am]).toString();
      subjectController.text = widget.data["subject"];
      discriptionController.text = widget.data["discription"];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dateTime = DateFormat.yMd().format(DateTime.now());
    themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          elevation:
              widget.data == null ? 0 : Theme.of(context).appBarTheme.elevation,
          backgroundColor: widget.data == null
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: widget.data == null
                    ? EdgeInsets.only(top: MySize.size0)
                    : EdgeInsets.only(top: MySize.size20),
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: MySize.size100 * 1.6,
                  // decoration: BoxDecoration(
                  //     color: Colors.blue,
                  //     borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              top: 10.0,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: MySize.size100 * 2.9,
                                  // height: MySize.size10,
                                  child: customTextField(
                                    _dateController,
                                    "Enter date",
                                    "Choose Date",
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                  icon: Icon(Icons.date_range_rounded),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              top: 10.0,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: MySize.size100 * 2.9,
                                  // height: MySize.size10,
                                  child: customTextField(
                                    _timeController,
                                    "Enter Time",
                                    "Choose Time",
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _selectTime(context);
                                  },
                                  icon: Icon(Icons.watch_later_rounded),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                height: MySize.size100 * 1.6,
                // decoration: BoxDecoration(
                //     color: Colors.blue,
                //     borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 10.0,
                            top: 10.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MySize.size100 * 2.9,
                                // height: MySize.size10,
                                child: customTextField(
                                  subjectController,
                                  "Enter Subject",
                                  "Enter Subject",
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.subject_outlined),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 10.0,
                            top: 10.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MySize.size100 * 2.9,
                                // height: MySize.size10,
                                child: customTextField(
                                  discriptionController,
                                  "Enter Description",
                                  "Enter Description",
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.description),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.black,
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.green.shade400,
                  ),
                ),
                onPressed: () {
                  if (widget.data == null) {
                    postData();
                  } else {
                    postUpdateData();
                  }
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                label: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
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
          keyboardType: TextInputType.text,
        ),
        SizedBox(
          height: 7,
        )
      ],
    );
  }
}
