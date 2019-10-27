import 'package:flutter/material.dart';
import 'package:sjcehostelredressal/firstpage.dart';
import 'package:sjcehostelredressal/ui/LoginPage.dart';

void main() => runApp(MyApp1());

class MyApp1 extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyApp(),
    );
  }
}
