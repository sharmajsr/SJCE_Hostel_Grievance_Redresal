import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  File sampleImage;
  String filename;
  String random;
  var url;
  bool validateName = true;
  bool validateNumber = true;
  bool validateDetail = true;
  static const typeItems = <String>['General', 'Electrical', 'Sanitation','Civil','Food'];
  final List<DropdownMenuItem<String>> _dropDownMenuItems = typeItems
      .map((String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  ))
      .toList();
  String dropDownValue = "General";

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    setState(() {
      sampleImage = tempImage;
      filename = sampleImage.toString();
    });
  }
  static const textStyle=TextStyle(fontSize: 15);
  TextEditingController nameController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff028090),
        title: Text('Create Complaint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ListView(
          children: <Widget>[
            Text('Enter your Name',style:textStyle),
            TextField(
              controller: nameController,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 6),
              child: Text('Enter details',style:textStyle),
            ),
            TextField(
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              controller: infoController,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 6),
              child: Text('Enter phone',style:textStyle),
            ),
            TextField(maxLength: 10,
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(prefixText: '+91-',),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 6),
              child: Text('Select Category',style:textStyle),
            ),
            DropdownButton(
              isExpanded: true,
              items: this._dropDownMenuItems,
              onChanged: (String newValue) {
                setState(() {
                  dropDownValue = newValue;
                });
              },
              value: dropDownValue,
            ),
            RaisedButton(
              onPressed: getImage,
              child:
              sampleImage == null ? Text('Pick an image') : uploadPicture(),
            ),
            RaisedButton(
              color: Color(0xff028090),
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white,fontSize: 17),
              ),
              onPressed: () async {
                setState(() {
                  validateName = nameController.text.isEmpty ? false : true;
                  validateDetail = infoController.text.isEmpty ? false : true;
                  validateNumber = phoneController.text.isEmpty ? false : true;
                });
                random = randomAlphaNumeric(6);
                var url = await uploadImage();

                Map data = {
                  "name": "${nameController.text.trim()}",
                  "detail": "${infoController.text.trim()}",
                  "phone": "${phoneController.text.trim()}",
                  "url": "${url.toString()}",
                  "id": "${random}",
                  "category":"${dropDownValue}",
                  "status": "Pending"
                };
                if (validateName && validateNumber && validateNumber)
                  database.reference().child("hostel/" + random).set(data);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadPicture() {
    return Container(
      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.file(
            sampleImage,
            height: 200,
            width: 200,
          ),
          RaisedButton(
            elevation: 7.0,
            child: Text('Select another'),
            onPressed: getImage,
          ),
        ],
      ),
    );
  }

  Future<String> uploadImage() async {
    // print('\n\n$filename\n\n');
    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('$random');
    final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
    var downUrl = await (await task.onComplete).ref.getDownloadURL();
    url = downUrl.toString();
    //print('Download Url $url');
    return url;
  }
}
