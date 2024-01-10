import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tttttt/%ED%99%88%20%EC%9C%84%EC%A0%AF/noti_page.dart';

class NotificationGridView extends StatefulWidget {
  const NotificationGridView({Key? key}) : super(key: key);

  @override
  _NotificationGridViewState createState() => _NotificationGridViewState();
}

class _NotificationGridViewState extends State<NotificationGridView> {
  final CollectionReference notiCollection =
      FirebaseFirestore.instance.collection('noti');

  late Future<QuerySnapshot> notificationsFuture;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    notificationsFuture = notiCollection.get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: notificationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No data available');
        } else {
          final notifications = snapshot.data!.docs;

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 2,
            //   mainAxisExtent: 200,
            // ),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final notiText = notification['noti'];
              final notiTimestamp =
                  notification['date'] as Timestamp; // 타임스탬프 필드 읽기
              final notiDate = notiTimestamp.toDate();
              final subText = notification['sub'];

              final dateFormatter = DateFormat('yyyy-MM-dd'); // 원하는 날짜 형식 설정
              final formattedDate = dateFormatter.format(notiDate);

              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => NotificationDetailPage(
                        myNotification: MyNotification(
                      notiText: notiText,
                      subText: subText,
                      notiDate: notiDate,
                    )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(45, 194, 194, 194),
                            spreadRadius: .1,
                            blurRadius: 10,
                            offset: Offset(0, 10))
                      ],
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notiText,
                            style:
                                Theme.of(context).textTheme.titleLarge!.merge(
                                      const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(formattedDate),
                          ),
                          SizedBox(
                            child: RichText(
                              maxLines: 3,
                              text: TextSpan(
                                text: subText,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .merge(
                                      const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}