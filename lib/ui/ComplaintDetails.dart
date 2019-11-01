import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ComplaintDetails extends StatefulWidget {
  String name;
  String detail;
  String phone;
  String url;
  String status;
  String id;
  String category;
  int flag;


  ComplaintDetails(this.name, this.detail, this.phone, this.url, this.status,
      this.id, this.category,this.flag);

  @override
  _ComplaintDetailsState createState() => _ComplaintDetailsState();
}

final FirebaseDatabase database = FirebaseDatabase.instance;

class _ComplaintDetailsState extends State<ComplaintDetails> {
  Map data;
  String message;
  bool val;
  String statusChange;
  String pText = "Pending";
  String dText = "Done";

  void initState() {
    //super.initState();
    if (this.widget.status == "Done") {
      val = true;
      statusChange = dText;
    } else {
      val = false;
      statusChange = pText;
    }
  }

  static const textStyle = TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff028090),
        title: Text('ComplaintDetail'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6),
        child: ListView(
          children: <Widget>[
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 6.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(height: 400,
                         width: 400,
                        child: Image.network(
                          widget.url,
                        ),
                      ),
// Image.asset(
//                      'assets/dp.jpg',
//                    )),
                      Text(
                        'Name : ${widget.name}',
                        style: textStyle,
                      ),
                      Text(
                        'Number : ${widget.phone}',
                        style: textStyle,
                      ),
                      Text(
                        'Detail : ${widget.detail}',
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                      Text(
                        'ID :  ${widget.id}',
                        style: textStyle,
                      ),
                      Text(
                        'Status : $statusChange',
                        style: TextStyle(fontSize: 16,
                            color: statusChange == "Pending"
                                ? Colors.red
                                : Colors.green),
                      ),

                      widget.flag == 0
                          ? Container()
                          :Row(
                        children: <Widget>[
                          Text('Work Done'),
                          Checkbox(
                            value: this.val,
                            onChanged: (value) {
                              setState(() {
                                this.val = value;
                                if (this.val == true)
                                  message = "Done";
                                else
                                  message = "Pending";
                                statusChange = message;
                                data = {
                                  "name": "${widget.name}",
                                  "detail": "${widget.detail}",
                                  "phone": "${widget.phone}",
                                  "url": "${widget.url}",
                                  "id": "${widget.id}",
                                  "status": "$message",
                                  "category":"${widget.category}"
                                };
                                database
                                    .reference()
                                    .child("hostel/" +widget.category +'/'+ widget.id)
                                    .set(data);

                                //database.reference().child("hostel").update(data).then((data){print('data');});
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
