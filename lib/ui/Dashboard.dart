import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sjcehostelredressal/model/complaints.dart';
import 'package:sjcehostelredressal/ui/ComplaintDetails.dart';
import 'package:sjcehostelredressal/ui/admin.dart';
import 'package:sjcehostelredressal/ui/form.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Dashboard extends StatefulWidget {
  int loginTypeFlag;

  Dashboard(this.loginTypeFlag);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Complaints> complaintList = List();
  Complaints complaint;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    complaint = Complaints("", "", "", "");
    databaseReference = database.reference().child("hostel");
    databaseReference.onChildAdded.listen(onDataAdded);
  }

  static const textStyle = TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyForm()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body:
//      ListView(
//        children: <Widget>[
//          Flexible(
//            child: Container(
//              height: 100,
//              child: ListView(
//                //itemExtent: 3,
//           //   scrollDirection: Axis.horizontal,
//                children: <Widget>[
//                Row(
//                  children: <Widget>[
//                    RaisedButton(color: Colors.red,onPressed: (){},child: Text('General'),),
//                    RaisedButton(onPressed: (){},child: Text('Electricity'),),
//                    RaisedButton(onPressed: (){},child: Text('Santitaion'),),
//                  ],
//                ),
//
//                ],
//              ),
//            ),
//          ),],
//    ),
          FirebaseAnimatedList(defaultChild: CircularProgressIndicator(),
              query: databaseReference.orderByChild('timestamp'),
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map<dynamic, dynamic> data = snapshot.value;

                if (snapshot == null)
                  return Center(child: CircularProgressIndicator( ));
                else
                  return eventCard(
                      data["name"],
                      data["detail"],
                      data['phone'],
                      data['url'],
                      data["status"],
                      data['id'],
                      data['category'],
                      widget.loginTypeFlag);
              }),


    );
  }

  Widget eventCard(String name, String detail, String phone, String url,
      String status, String id, String category, int flag) {
    if (id == null) id = "";
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ComplaintDetails(
                    name, detail, phone, url, status, id, flag)));
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
// Image.asset(
//                      'assets/dp.jpg',
//                    )),
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
  }

  void onDataAdded(Event event) {
    setState(() {
      complaintList.add(Complaints.fromSnapshot(event.snapshot));
    });
  }
}
