import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationDetailPage extends StatelessWidget {
  final MyNotification myNotification;

  const NotificationDetailPage({Key? key, required this.myNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('동아리 소식'),
        backgroundColor: Colors.blue[700],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myNotification.notiText,
                      style: const TextStyle(
                          fontSize: 24, fontFamily: 'Pretendard'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm')
                          .format(myNotification.notiDate),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      myNotification.subText,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyNotification {
  final String notiText;
  final String subText;
  final DateTime notiDate;

  MyNotification({
    required this.notiText,
    required this.subText,
    required this.notiDate,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Detail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotificationDetailPage(
        myNotification: MyNotification(
          notiText: 'Notification Title',
          subText: 'This is the content of the notification.',
          notiDate: DateTime.now(),
        ),
      ),
    );
  }
}