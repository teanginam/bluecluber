import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/pages/board/event_detail_page.dart';
import 'package:tttttt/providers/event_provider.dart';

class EventScreen extends StatelessWidget {
  EventScreen({super.key, required this.clubId});
  final clubId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: Provider.of<EventProvider>(context, listen: false)
                .fetchEventList(clubId),
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<EventProvider>(builder: (context, provider, _) {
                    return ListView.builder(
                      itemCount: provider.eventList.length,
                      itemBuilder: (context, index) {
                        final event = provider.eventList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailPage(event: event)));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFE0E0E0)),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                            key: UniqueKey(),
                                            imageUrl: event.imageUrl!,
                                            imageBuilder: ((context, imageProvider) => Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    image: DecorationImage(
                                                        image: imageProvider, fit: BoxFit.cover),
                                                  ),
                                                )),
                                            placeholder: (context, url) => Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16.0),
                                                  color: Colors.white),
                                            ),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.title!,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('${event.dateTime}'),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  event.content!,
                                                  overflow: TextOverflow
                                                      .ellipsis, // 오버플로우시 ...으로 줄여 표시
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                            Text('더보기')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  })));
  }
}
