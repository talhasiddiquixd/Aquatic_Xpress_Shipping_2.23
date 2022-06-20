import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintPage extends StatefulWidget {
  PrintPage({Key? key}) : super(key: key);

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> devices=[];
  String deviceMessage="";
  final f=NumberFormat("\$###,###.00","en_US");


  @override
  void initState() {
    super.initState();
   
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {initPrinter(); });
  }
Future<void> initPrinter()async {
bluetoothPrint.startScan(timeout: Duration(seconds: 2));
if(!mounted) return;

  bluetoothPrint.scanResults.listen((val) {
    if(!mounted) return;
    setState(() { 
devices=val;});
if(devices.isEmpty)
setState(() {
  deviceMessage="No Device";
});

});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}