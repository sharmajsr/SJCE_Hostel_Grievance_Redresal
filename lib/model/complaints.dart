import 'package:firebase_database/firebase_database.dart';

class Complaints {
  String key;
  String name;
  String detail;
  String status;
  String phone;


  Complaints(this.name,this.detail,this.status,this.phone);

  Complaints.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["name"],
        detail= snapshot.value["detail"],
        status= snapshot.value["status"],
        phone =snapshot.value["phone"];



  toJson() {
    return {
      "name": name,
      "detail": detail,
      "status": status,
      "phone":phone
    };
  }
}