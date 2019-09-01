import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sjcehostelredressal/model/complaints.dart';
import 'package:sjcehostelredressal/ui/ComplaintDetails.dart';
import 'package:sjcehostelredressal/ui/admin.dart';
import 'package:sjcehostelredressal/ui/form.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
  Map<String, bool> checkboxVal;

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
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.security),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminDashboard()));
              },
            ),
          ],
          title: Text('Dashboard'),
        ),
        body: FirebaseAnimatedList(
            query: databaseReference,
            itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation,
                int index) {
              Map<dynamic, dynamic> data = snapshot.value;
              //checkboxVal.(data['id']:false);
              if (snapshot == null)
                return Center(child: CircularProgressIndicator());
              else
                return eventCard(data["name"], data["detail"], data['phone'],
                    data['url'], data["status"], data['id']);
            }));
  }

  Widget eventCard(String name, String detail, String phone, String url,
      String status, String id) {
    if (id == null) id = "";
    return InkWell(
      onTap: () {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) =>
//                    ComplaintDetails(name, detail, phone, url, status, id,flag)));
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
                  Spacer(),
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
