import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
   String? id;
   String? clubId; //해당동아리 id
   String? title;
   String? content;
   String? userId;
   DateTime? dateTime;
   String? imageUrl;

  Event(
      {
      this.id,
      this.clubId,
      this.title,
      this.content,
      this.userId,
      this.dateTime,
      this.imageUrl });


      factory Event.fromJson(Map<String, dynamic> json, String id) {
    return Event(
      id: id,
      clubId: json['clubId'],
      title : json['title'] ?? '',
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      dateTime: json['datetime'] != null ? (json['datetime'] as Timestamp).toDate() : DateTime.now(),
      imageUrl: json['imageUrl'],
      );
  }
}