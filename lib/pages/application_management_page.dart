import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/providers/club_provider.dart';
import 'package:tttttt/providers/application_provider.dart';

class ApplicationManagementPage extends StatelessWidget {
  const ApplicationManagementPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final appliedList = Provider.of<ApplicationProvider>(context).appliedUserList;

    return Scaffold(
      appBar: AppBar(
        title: Text("신청관리"),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("신청목록"),
          ListView.builder(
              shrinkWrap: true,
              itemCount: appliedList.length,
              itemBuilder: ((context, index) {
                final user = appliedList[index];
                return Row(
                  children: [
                    Text(user.name),
                    CupertinoButton.filled(
                        child: Text('수락'),
                        onPressed: () {
                          //멤버에 추가
                          Provider.of<ApplicationProvider>(context, listen: false)
                              .accept(context, id, user.uid);
                        }),
                    CupertinoButton.filled(child: Text('거절'), onPressed: () {
                           Provider.of<ApplicationProvider>(context, listen: false)
                              .refuse(context, id, user.uid);

                    })
                  ],
                );
              })),
          Divider(
            thickness: 3,
          ),
          Text("신청기간"),
          Consumer<ClubProvider>(
            builder: (context, clubProvider, child) {
              final club =
                  clubProvider.clubList.firstWhere((club) => club.id == id);
              var formatter = DateFormat('yyyy년 MM월 dd일');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("시작시간"),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<ApplicationProvider>(context, listen: false)
                          .selectedApplicationPeriod(
                              context, club.applicationPeriodStart, id, true);
                    },
                    child: Text("${formatter.format(club.applicationPeriodStart)} 시작시간 설정"),
                  ),
                  Text("종료시간"),
                  ElevatedButton(
                      onPressed: () {
                        Provider.of<ApplicationProvider>(context, listen: false)
                            .selectedApplicationPeriod(
                                context, club.applicationPeriodEnd, id, false);
                      },
                      child: Text("${formatter.format(club.applicationPeriodEnd)} 종료시간 설정")),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
