import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? eventId; //해당동아리 id
  String? content;
  String? userId;
  DateTime? dateTime;

  Comment({
    this.eventId,
    this.content,
    this.userId,
    this.dateTime,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      eventId: json['eventId'],
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      dateTime: json['datetime'] != null
          ? (json['datetime'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
