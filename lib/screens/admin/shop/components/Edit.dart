import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/admin/shop/components/my_products.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class Edit extends StatefulWidget {
  const Edit(
      {Key? key,
      this.data,
      this.name,
      this.details,
      this.price,
      this.color,
      this.stock,
      this.id})
      : super(key: key);
  final data, name, details, price, color, stock, id;

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  File? _image;
  String? base64Image;
  File? tempfile;
  String? fileName;
  TextEditingController nameController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  var response;

  updateDataWithoutPicture() async {
    String? token = await getToken();

    var headers = {
      'Authorization': 'Bearer $token",',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request(
        'PUT',
        Uri.parse('${getCloudUrl()}/api/products/' +
            widget.id.toString()));
    request.bodyFields = {
      'Name': nameController.text,
      'Details': detailController.text,
      'Color': colorController.text,
      'Price': priceController.text,
      'Stock': stockController.text
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyProducts()));
    } else {
      print(response.reasonPhrase);
    }
  }

  updateData() async {
    String? token = await getToken();

    var headers = {'Authorization': 'Bearer $token",'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('${getCloudUrl()}/api/products/' +
            widget.id.toString()));
    request.fields.addAll({
      'Name': nameController.text,
      'Details': detailController.text,
      'Color': colorController.text,
      'Price': priceController.text,
      'Stock': stockController.text
    });
    request.headers.addAll(headers);

    request.files.add(await http.MultipartFile.fromPath('Image', _image!.path));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyProducts()));
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name.toString();
    detailController.text = widget.details.toString();
    priceController.text = widget.price.toString();
    colorController.text = widget.color.toString();
    stockController.text = widget.stock.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: MySize.size20,
              right: MySize.size20,
              top: MySize.size30,
              bottom: MySize.size20),
          child: Column(
            children: [
              imageProfile(),
              Padding(
                padding:
                    EdgeInsets.only(top: MySize.size10, bottom: MySize.size10),
                child: customTextField(nameController, "", "Name"),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MySize.size10),
                child: customTextField(detailController, "", "Detail"),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MySize.size10),
                child: customTextField(priceController, "", "Price"),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MySize.size10),
                child: customTextField(colorController, "", "Color"),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MySize.size10),
                child: customTextField(stockController, "", "Stock"),
              ),
              ElevatedButton(
                //style: style,
                onPressed: () {
                  if (_image == null) {
                    updateDataWithoutPicture();
                  } else {
                    updateData();
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.2,
            child: _image == null
                ? Image.memory(base64Decode(widget.data.toString()))
                : Image.memory(base64Decode(base64Image.toString()))),
        Positioned(
          bottom: MySize.size16,
          right: MySize.size10,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.blueGrey,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
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
          keyboardType: TextInputType.text,
        ),
        SizedBox(
          height: 7,
        )
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      color: Colors.white,
      height: MySize.size120,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera, color: Colors.green,),
              onPressed: () {
                _takePhoto();
                Navigator.pop(context);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image, color: Colors.green),
              onPressed: () {
                takePhotoFromGallery();
                Navigator.pop(context);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  final picker = ImagePicker();
  void _takePhoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        tempfile = _image;
        fileName = tempfile!.path.split('/').last;
        List<int> imageBytes = _image!.readAsBytesSync();

        base64Image = base64Encode(imageBytes);
      } else {
        print('No image selected.');
      }
    });
  }

  void takePhotoFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        tempfile = _image;
        fileName = tempfile!.path.split('/').last;
        List<int> imageBytes = _image!.readAsBytesSync();

        base64Image = base64Encode(imageBytes);
      } else {
        print('No image selected.');
      }
    });
  }
}
