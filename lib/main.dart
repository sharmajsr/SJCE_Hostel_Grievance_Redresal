import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjcehostelredressal/login.dart';
import 'package:sjcehostelredressal/ui/UserDashboard.dart';
import 'package:sjcehostelredressal/ui/admin.dart';
import 'package:sjcehostelredressal/utils/CommonData.dart';
import 'package:sjcehostelredressal/utils/Constants.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    //super.initState();
   // CommonData.clearLoggedInUserData();
    shared();
  }

  String _login,_role;

  shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _login = (prefs.getString(Constants.isLoggedIn));
      _role=(prefs.getString(Constants.loggedInUserRole));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home : //_login=="true" ? ( _role == "student" ? UserDashboard() : AdminDashboard() ) :
      Login(),
    );
  }
}
