import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String name;
  final String information;
  final String introduction;
  final String president;
  final String tag;
  final int members;

  final DocumentReference<Map<String, dynamic>> docRef;
  final List<String> memberNames;
  final List<String> memberUids;

  Club(
    this.name,
    this.information,
    this.introduction,
    this.president,
    this.members,
    this.docRef,
    this.memberNames,
    this.memberUids,
    this.tag,
  );
}
