import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjcehostelredressal/utils/Constants.dart';

//test
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
  bool validateDetail = false;
  String _name, _mobile, _block, _room;

  @override
  void initState() {
    super.initState();
    shared();
  }

  shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString(Constants.loggedInUserName));
      _mobile = (prefs.getString(Constants.loggedInUserMobile));
      _block = (prefs.getString(Constants.loggedInUserBlock));
      _room = (prefs.getString(Constants.loggedInUserRoom));
    });
  }

  bool validateName = true;
  bool validateNumber = true;

  static const typeItems = <String>[
    'General',
    'Electrical',
    'Sanitation',
    'Civil',
    'Food'
  ];
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
//        if(sampleImage==null)
//           sampleImage= File("assets/image_02.png");
           sampleImage = tempImage;
      filename = sampleImage.toString();
    });
  }

  static const textStyle = TextStyle(fontSize: 15);
  TextEditingController nameController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool saving=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff028090),
        title: Text('Create Complaint'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: saving,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: ListView(
            children: <Widget>[
//            Text('Enter your Name',style:textStyle),
//            TextField(
//              controller: nameController,
//            ),
              Padding(
                padding: const EdgeInsets.only(top: 14.0, bottom: 6),
                child: Text('Enter details', style: textStyle),
              ),
              TextField(
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    value.isEmpty
                        ? validateDetail = true
                        : validateDetail = false;
                  });
                },
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  errorText: validateDetail ? "Detail can\'t be empty" : null,
                  border: OutlineInputBorder(),
                ),
                controller: infoController,
              ),
//            Padding(
//              padding: const EdgeInsets.only(top: 14.0, bottom: 6),
//              child: Text('Enter phone',style:textStyle),
//            ),
//            TextField(maxLength: 10,
//              controller: phoneController,
//              keyboardType: TextInputType.number,
//              decoration: InputDecoration(prefixText: '+91-',),
//            ),
              Padding(
                padding: const EdgeInsets.only(top: 14.0, bottom: 6),
                child: Text('Select Category', style: textStyle),
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
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                onPressed: () async {
                  saving=true;
                  setState(() {
                    validateName = nameController.text.isEmpty ? false : true;
                    validateDetail = infoController.text.isEmpty ? true : false;
                    validateNumber = phoneController.text.isEmpty ? false : true;
                  });
                  random = randomAlphaNumeric(6);


                   var url = await uploadImage();


                  Map data = {
                    "name": "$_name",
                    "detail": "${infoController.text.trim()}",
                    "phone": "$_mobile",
                    "url": "${url.toString()}",
                    "id": "${random}",
                    "category": "${dropDownValue}",
                    "block": "$_block",
                    "room": "$_room",
                    "status": "Pending"
                  };
                  if (!validateDetail)
                    database
                        .reference()
                        .child("hostel/" + dropDownValue + '/' + random)
                        .set(data);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
