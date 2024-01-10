import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/models/comment.dart';
import 'package:tttttt/providers/comment_provider.dart';
import 'package:tttttt/providers/user_provider.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key, required this.event});

  final event;
  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final _controller = TextEditingController();
  final UserProvider userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    var _comment = Comment(
      eventId: widget.event.id,
      content: '',
      dateTime: null,
      userId: userProvider.currentUser!.uid,
    );
    final event = widget.event;
    return Scaffold(
      appBar: AppBar(
        title: Text("행사 게시판"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text('${event.dateTime}'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(event.content),
                    CachedNetworkImage(
                      key: UniqueKey(),
                      imageUrl: event.imageUrl!,
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),

                    Divider(
                      thickness: 2,
                    ),
                    // 댓글창
                    FutureBuilder(
                        future:
                            Provider.of<CommentProvider>(context, listen: false)
                                .fetchCommentList(event.id),
                        builder: (context, snapshot) {
                          print(event.id);
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("아직 댓글이 없습니다.");
                          }

                          return Consumer<CommentProvider>(
                              builder: (context, provider, _) {
                            return ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                controller:
                                    ScrollController(keepScrollOffset: false),
                                itemCount: provider.commentList.length,
                                itemBuilder: ((context, index) {
                                  final comment = provider.commentList[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 유저이름
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            comment.userId!,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // deleteCommentDialog(commentID);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              size: 17,
                                            ),
                                          )
                                        ],
                                      ),
                                      // 댓글
                                      Text(
                                        comment.content!,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      // 댓글 단 시간
                                      Text(
                                        '${comment.dateTime}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Divider(
                                        thickness: 2,
                                      )
                                    ],
                                  );
                                }));
                          });
                        }),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SizedBox(
                height: 60,
                child: Expanded(
                    child: TextField(
                  maxLines: null,
                  controller: _controller,
                  onChanged: ((value) {
                    _comment.content = value;
                  }),
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                        onTap: () async {
                          _comment.content!.trim().isEmpty
                              ? null
                              : await Provider.of<CommentProvider>(context,
                                      listen: false)
                                  .write(_comment);
                          _controller.clear();
                        },
                        child: Icon(Icons.send)),
                    hintText: '댓글을 입력하세요.',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //댓글 달기 기능
  // void writeComment() async {
  //   _controller.clear();
  //   final userData = await CurrentUser.getDocRef().get();
  //   FirebaseFirestore.instance
  //       .doc(eventData['clubPath'])
  //       .collection('events')
  //       .doc(eventData['eventPath'])
  //       .collection('comment')
  //       .add({
  //     'comment': comment,
  //     'name': userData['name'],
  //     'uid': CurrentUser.getUid(),
  //     'time': Timestamp.now(),
  //   });
  // }

  // 댓글 삭제 기능
  // void deleteComment(String commentID) async {
  //   FirebaseFirestore.instance
  //       .doc(eventData['clubPath'])
  //       .collection('events')
  //       .doc(eventData['eventPath'])
  //       .collection('comment')
  //       .doc(commentID)
  //       .delete();
  // }

  // 댓글 삭제 다이얼로그
  // void deleteCommentDialog(String commentID) {
  //   showCupertinoDialog(
  //       context: context,
  //       builder: (context) {
  //         return CupertinoAlertDialog(
  //           title: Text('삭제'),
  //           content: Text('댓글을 삭제하시겠습니까?'),
  //           actions: [
  //             CupertinoDialogAction(
  //               isDestructiveAction: true,
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: const Text('취소'),
  //             ),
  //             CupertinoDialogAction(
  //               isDefaultAction: true,
  //               onPressed: () {
  //                 deleteComment(commentID);
  //                 Navigator.pop(context);
  //               },
  //               child: const Text('확인'),
  //             ),
  //           ],
  //         );
  //       });
  // }
}
