
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/pages/board_page.dart';
import 'package:tttttt/providers/club_provider.dart';

import 'package:tttttt/providers/user_provider.dart';
import 'package:tttttt/widgets/club_detail/club_profile.dart';
import 'package:tttttt/widgets/club_detail/club_profile_image.dart';

class ClubDetailPage extends StatelessWidget {
  const ClubDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    var formatter = DateFormat('yyyy년 MM월 dd일');
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue[700],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ClubProvider>(builder: (context, clubProvider, child) {
              final club =
                  clubProvider.clubList.firstWhere((club) => club.id == id);
              return Container(
                height: 180,
                color: Colors.blue[700],
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                child: Row(
                  children: [
                    //동아리 이미지
                    ClubProfileImage(id: id, club: club),
                    const SizedBox(
                      width: 20.0,
                    ),
                    // 동아리명, 멤버수, 가입신청버튼
                    ClubProfile(club: club, formatter: formatter, user: user, id: id),
                  ],
                ),
              );
            }),

            //소개글---------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "소개글",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.2,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Colors.grey[300],
                            ),
                            child: Text('club.introduction'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          //공지
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '공지',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => BoardPage(id : id)));
                                  },
                                  child: Text(
                                    "더보기 >",
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12.0),
                                  ))
                            ],
                          ),

                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.2,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Colors.grey[300],
                            ),
                          ),
                          //행사
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "행사",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    // Get.to(const BoardPage(),
                                    //     arguments: club);
                                  },
                                  child: Text(
                                    "더보기 >",
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12.0),
                                  ))
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.2,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }


}

