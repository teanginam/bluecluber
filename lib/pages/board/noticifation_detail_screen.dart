import 'package:flutter/material.dart';


class NotificationDetailScreen extends StatelessWidget {
   const NotificationDetailScreen({super.key, required this.noti});

  final noti;
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
                     noti.title,
                      style: const TextStyle(
                          fontSize: 24, fontFamily: 'Pretendard'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                     '${noti.dateTime}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      noti.content,
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