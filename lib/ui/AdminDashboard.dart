import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sjcehostelredressal/login.dart';
import 'package:sjcehostelredressal/model/complaints.dart';
import 'package:sjcehostelredressal/ui/ComplaintDetails.dart';
import 'package:sjcehostelredressal/utils/CommonData.dart';

class AdminDashboard extends StatefulWidget {
  int loginTypeFlag;

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  List<Complaints> complaintList = List();
  Map<dynamic, dynamic> data;

  Complaints complaint;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;
  TabController tabBarController;

  @override
  void initState() {
    super.initState();
    complaint = Complaints("", "", "", "");
    databaseReference = database.reference();
    databaseReference.onChildAdded.listen(onDataAdded);
    firebaseList;

    tabBarController =
        new TabController(length: 5, vsync: this, initialIndex: 0);
  }
  Widget shimmers(){
    return ListView(
      children: <Widget>[
        shimmerCard(),
        shimmerCard(),
        shimmerCard(),
        shimmerCard(),
        shimmerCard(),
        shimmerCard()
      ],    );
  }
  Widget shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
//        child: Column(
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.only(bottom: 8.0),
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Container(
//                    width: 48.0,
//                    height: 48.0,
//                    color: Colors.white,
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                  ),
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Container(
//                          width: double.infinity,
//                          height: 8.0,
//                          color: Colors.white,
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.symmetric(vertical: 2.0),
//                        ),
//                        Container(
//                          width: double.infinity,
//                          height: 8.0,
//                          color: Colors.white,
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.symmetric(vertical: 2.0),
//                        ),
//                        Container(
//                          width: 40.0,
//                          height: 8.0,
//                          color: Colors.white,
//                        ),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  static const textStyle = TextStyle(
    fontSize: 16,
  );
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => exit(0),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
//    var _fabLocation=kFabCenterDocked;
//    static const  kFabCenterDocked = _fabLocation<FloatingActionButtonLocation>(
//      title: 'Attached - Center',
//      label: 'floating action button is docked at the center of the bottom app bar',
//      value: FloatingActionButtonLocation.centerDocked,
//    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            GestureDetector(child: Icon(Icons.send,color: Colors.white,),onTap: (){
              CommonData.clearLoggedInUserData();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },)
          ],
          backgroundColor: Color(0xff028090),
          title: Text('Admin Dashboard'),
          bottom: TabBar(
            controller: tabBarController,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: Colors.white),
                insets: EdgeInsets.symmetric(horizontal: 0.0)),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 15,

            unselectedLabelStyle: TextStyle(
                color: Colors.black26,
                fontSize: 15.0,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w400),
            unselectedLabelColor: Colors.grey.shade400,
            labelColor: Colors.white,
            isScrollable: true,
            labelStyle: TextStyle(
                fontSize: 15.0, letterSpacing: 1.2, fontWeight: FontWeight.w700),
//          indicatorColor: Colors.blue,
//          labelColor: Colors.white,
//          unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                child: Text('General'),
              ),
              Tab(
                child: Text('Electrical'),
              ),
              Tab(
                child: Text('Civil'),
              ),
              Tab(
                child: Text('Sanitation'),
              ),
              Tab(
                child: Text('Food'),
              ),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: tabBarController,
            children: <Widget>[
              firebaseList('General'),
              firebaseList('Electrical'),
              firebaseList('Civil'),
              firebaseList('Sanitation'),
              firebaseList('Food'),
            ],
          ),
        ),
      ),
    );
  }

//
//  Widget callEventCard(String complaintType) {
//   // return ListView.builder(itemCount: data.length,itemBuilder: (BuildContext context,int index){
//  for(int i=0;i<data.length;i++) {
//
//    if(data['category']==complaintType)
//    return eventCard(
//        data["name"],
//        data["detail"],
//        data['phone'],
//        data['url'],
//        data["status"],
//        data['id'],
//        data['category'],
//        widget.loginTypeFlag);
//  }
//   // );
//  }

  Widget firebaseList(String complaintType) {
    return FirebaseAnimatedList(
        defaultChild: Center(child: shimmers()),
        query: databaseReference.child('hostel/' + complaintType),
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int index) {
          data = snapshot.value;
          print('${data['name']}');
          if (complaintType == data['category'])
            return eventCard(
                data["name"],
                data["detail"],
                data['phone'],
                data['url'],
                data["status"],
                data['id'],
                data['category'],
                complaintType,
                1);
          else
            return Container();
        });
  }

  Widget eventCard(
      String name,
      String detail,
      String phone,
      String url,
      String status,
      String id,
      String category,
      String complaintType,
      int flag) {
//    print('$name $category $complaintType');
    //  if(category==complaintType)
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ComplaintDetails(
                    name, detail, phone, url, status, id, category, flag)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6),
        child: Container(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    width: 100,
                    height: 100,
                    child: Image.network(
                      url,
                      height: 150,
                      width: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Name : $name',
                          style: textStyle,
                        ),
                        Text(
                          'ID : $id',
                          style: textStyle,
                        ),
                        Text(
                          'Number : $phone',
                          style: textStyle,
                        ),
                        Text(
                          'Category : $category',
                          style: textStyle,
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                            'Detail : $detail',
                            overflow: TextOverflow.ellipsis,
                            style: textStyle,
                          ),
                        ),
                        Text(
                          'Status : $status',
                          style: TextStyle(
                              color: status == "Pending"
                                  ? Colors.red
                                  : Colors.green),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
//    else
//      return Container();
  }

  void onDataAdded(Event event) {
    setState(() {
      complaintList.add(Complaints.fromSnapshot(event.snapshot));
    });
  }
}
