import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tttttt/models/comment.dart';

class CommentProvider with ChangeNotifier {
  List<Comment> _commentList = [];
  List<Comment> get commentList => _commentList;


  // 댓글 받아오기 메서드
  Future<void> fetchCommentList(String eventId) async {
    var db = FirebaseFirestore.instance;
    var querySnapshot = await db
        .collection("Comment")
        .where('eventId', isEqualTo: eventId) // Filter based on clubId
        .get();

    final List<Comment> result =
        querySnapshot.docs.map((e) => Comment.fromJson(e.data())).toList();
    _commentList.clear();
    _commentList.addAll(result);
    notifyListeners();
  }

  // 댓글 쓰기 메서드
  Future<void> write(Comment comment) async {
    try {
      FirebaseFirestore.instance.collection('Comment').add({
        'eventId' : comment.eventId,
        'content' : comment.content,
        'datetime': DateTime.now(),
        'userId': comment.userId,
      });

      final newComment = Comment(
        eventId : comment.eventId,
        content: comment.content,
        dateTime: DateTime.now(),
        userId: comment.userId,
      );

      _commentList.add(newComment);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
