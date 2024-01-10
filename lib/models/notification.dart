import 'package:cloud_firestore/cloud_firestore.dart';

class Noti {
   String? clubId; //해당동아리 id
   String? title;
   String? content;
   String? userId;
   DateTime? dateTime;

  Noti(
      {
      this.clubId,
      this.title,
      this.content,
      this.userId,
      this.dateTime, });


      factory Noti.fromJson(Map<String, dynamic> json) {
    return Noti(
      clubId: json['clubId'],
      title : json['title'] ?? '',
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      dateTime: json['datetime'] != null ? (json['datetime'] as Timestamp).toDate() : DateTime.now(),);
  }
}