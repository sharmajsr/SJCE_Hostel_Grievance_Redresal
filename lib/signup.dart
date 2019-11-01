import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sjcehostelredressal/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatelessWidget {
  Map data;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usnController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> signUp() async {
      try {
        AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        FirebaseUser user = result.user;

        Firestore.instance.collection("users").document((user.uid)).setData({
          "name": "${nameController.text}",
          "usn": "${usnController.text}",
          "block": "${blockController.text}",
          "room": "${roomController.text}",
          "mobile": "${mobileController.text}",
          "role": "student"
        });

        print(user);

//        StreamBuilder<DocumentSnapshot>(
//          stream: Firestore.instance.collection('users').document(user.uid).setData(data),
//          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
//            if(snapshot.hasError){
//              return Text('Error: ${snapshot.error}');
//      }
//            switch(snapshot.connectionState){
//              case ConnectionState.waiting: return Text('Loading');
//              default:
//                return Text(snapshot.data['name']);
//      }
//      },
//        )

//        final FirebaseUser user = (await FirebaseAuth.instance
//            .createUserWithEmailAndPassword(
//            email: emailController.text,
//            password: passwordController.text)).user;
        user.sendEmailVerification();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } catch (e) {
        print(e.message);
      }
    }

    return Scaffold(
      body: new Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("SignUp",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Name",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("USN No.",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                controller: usnController,
                decoration: InputDecoration(
                    hintText: "USN",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Hostel Block",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                controller: blockController,
                decoration: InputDecoration(
                    hintText: "Block",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Room No.",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                controller: roomController,
                decoration: InputDecoration(
                    hintText: "Room No.",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(35),
              ),
              Text("Mobile",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                maxLength: 10,
                controller: mobileController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Mobile",
                    prefixText: '+91-',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(35),
              ),
              Text("Email",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(35),
              ),
              Text("Password",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(35),
              ),
              InkWell(
                child: Center(
                  child: Container(
                    width: ScreenUtil.getInstance().setWidth(250),
                    height: ScreenUtil.getInstance().setHeight(60),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF6078ea).withOpacity(.3),
                              offset: Offset(0.0, 8.0),
                              blurRadius: 8.0)
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          data = {
                            "name": "${nameController.text}",
                            "usn": "${usnController.text}",
                            "block": "${blockController.text}",
                            "room": "${roomController.text}",
                            "mobile": "${mobileController.text}",
                            "role": "student"
                          };

                          signUp();
                        },
                        child: Center(
                          child: Text("SignUp",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins-bold",
                                  fontSize: 18,
                                  letterSpacing: 1.0)),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
