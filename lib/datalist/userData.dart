import 'package:cloud_firestore/cloud_firestore.dart';

class userData {
  late String name;
  late String department;
  late String? phoneNumber;
  late String studentID;
  List? membership;
  String? referenceId;

  userData(this.name, this.department, this.phoneNumber, this.studentID,
      this.membership,
      {this.referenceId});

  factory userData.fromSnapshot(DocumentSnapshot snapshot) {
    final user = userDataFromJson(snapshot.data() as Map<String, dynamic>);
    user.referenceId = snapshot.reference.id;
    return user;
  }
}

userData userDataFromJson(Map<String, dynamic> json) {
  return userData(
    json["name"] as String,
    json["department"] as String,
    json["phoneNumber"] as String,
    json["studentID"] as String,
    json["membership"] as List?,
  );
}




// class Map<string, dynamic>members {
//   String? name;
//   String? state;
//   Timestamp? setdate;

//   members() {
//     Map<String, dynamic> data = <String, dynamic>{};

//     data['name'] = name;
//     data['state'] = state;
//     data['setdate'] = setdate;
//   }
// }
