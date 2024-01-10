import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/pages/board/noticifation_detail_screen.dart';
import 'package:tttttt/providers/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, required this.clubId});

  final String clubId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<NotificationProvider>(context, listen: false)
            .fetchNotiList(clubId),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<NotificationProvider>(builder: (context, provider, _) {
                return ListView.builder(
                    itemCount: provider.notiList.length,
                    itemBuilder: (context, index) {
                      final noti = provider.notiList[index];
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                          child: Container(
                            color: const Color.fromARGB(255, 246, 246, 246),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationDetailScreen(noti: noti)));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color:
                                              Color.fromARGB(45, 194, 194, 194),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          noti.title!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .merge(
                                                const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text('${noti.dateTime}'),
                                        ),
                                        SizedBox(
                                          child: RichText(
                                            maxLines: 3,
                                            text: TextSpan(
                                              text: noti.content,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .merge(
                                                    const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
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
                            ),
                          ));
                    });
              }));
  }
}
