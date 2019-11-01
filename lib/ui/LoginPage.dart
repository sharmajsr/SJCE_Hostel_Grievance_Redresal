import 'package:flutter/material.dart';
import 'package:sjcehostelredressal/ui/AdminDashboard.dart';
import 'package:sjcehostelredressal/ui/UserDashboard.dart';
import 'package:sjcehostelredressal/utils/Constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff028090),
        title: Text('Login Page'),
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(color: Colors.lightGreen,
            child: Text('User'),
            onPressed: () {
            print("${Constants.loggedInName}");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      UserDashboard()
                  //    Dashboard(0)
                  ));
            },
          ),
          RaisedButton(color: Colors.blue,
            child: Text('Admin'),
            onPressed: () {

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()));
            },
          ),
        ],
      ),
    );
  }
}
