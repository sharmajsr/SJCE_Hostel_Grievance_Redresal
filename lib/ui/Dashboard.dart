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

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
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
    databaseReference = database.reference().child("hostel");
    databaseReference.onChildAdded.listen(onDataAdded);
    firebaseList;

    tabBarController =
        new TabController(length: 5, vsync: this, initialIndex: 0);

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
        bottom: TabBar(
          controller: tabBarController,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Colors.white,
              width: 4.0,
            ),
            insets: EdgeInsets.fromLTRB(40, 50, 40, 0),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 15,
          unselectedLabelStyle: TextStyle(
              color: Colors.black26,
              fontSize: 15.0,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w400),
          unselectedLabelColor: Colors.black26,
          labelColor: Color(0xff2d386b),
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
    );
  }

//
  Widget callEventCard(String complaintType) {
   // return ListView.builder(itemCount: data.length,itemBuilder: (BuildContext context,int index){
  for(int i=0;i<data.length;i++) {

    if(data['category']==complaintType)
    return eventCard(
        data["name"],
        data["detail"],
        data['phone'],
        data['url'],
        data["status"],
        data['id'],
        data['category'],
        widget.loginTypeFlag);
  }
   // );
  }

  Widget firebaseList(String complaintType) {
    return FirebaseAnimatedList(
        defaultChild: Center(child: CircularProgressIndicator()),
        query: databaseReference.orderByChild('timestamp'),
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int index) {
          data = snapshot.value;
          //if(complaintType == data['category'])
          return callEventCard(complaintType);
            // eventCard(
//              complaintType,
//              data["name"],
//              data["detail"],
//              data['phone'],
//              data['url'],
//              data["status"],
//              data['id'],
//              data['category'],
//              widget.loginTypeFlag);
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
      int flag) {
    print('$name $category');
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 6.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
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
  }

  void onDataAdded(Event event) {
    setState(() {
      complaintList.add(Complaints.fromSnapshot(event.snapshot));
    });
  }
}
