import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/models/club.dart';
import 'package:tttttt/models/user.dart';
import 'package:tttttt/pages/application_management_page.dart';
import 'package:tttttt/providers/application_provider.dart';
import 'package:tttttt/providers/user_provider.dart';

class ClubProfile extends StatelessWidget {
  const ClubProfile({
    super.key,
    required this.club,
    required this.formatter,
    required this.user,
    required this.id,
  });

  final Club club;
  final DateFormat formatter;
  final Users? user;
  final String id;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    DateTime now = DateTime.now();
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                club.name,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                "멤버수: ${club.member.length}명",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              //왜 바로 안고쳐지지 가입신청기간
              Text(
                '가입 신청 기간\n${formatter.format(club.applicationPeriodStart)}~\n${formatter.format(club.applicationPeriodEnd)}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Consumer<UserProvider>(builder: (context, userProvider, child) {
                bool isApplied = user!.applicationList.contains(club.id);
                bool isMember = club.member.contains(user.uid);
                bool isPresident =
                    club.member.isNotEmpty && club.member[0] == (user.uid);
                bool isApplicationPeriod = now.isAfter(club.applicationPeriodStart) && now.isBefore(club.applicationPeriodEnd);
                
                //멤버가 아예없으면 오류남

                if (isPresident) {
                  return ElevatedButton(
                      onPressed: () {
                        Provider.of<ApplicationProvider>(context, listen: false)
                            .findApplyUser(club.applicationList);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ApplicationManagementPage(id: club.id)));
                      },
                      child: Text("신청관리"));
                }

                if (!isApplicationPeriod) {
                  return const ElevatedButton(onPressed: null, child: 
                  Text("신청기간 마감"));
                }

                if (isMember) {
                  return SizedBox();
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          isApplied
                              ? Provider.of<UserProvider>(context,
                                      listen: false)
                                  .applyCancle(
                                      context, id, userProvider.user!.uid)
                              : Provider.of<UserProvider>(context,
                                      listen: false)
                                  .apply(context, id, userProvider.user!.uid);
                        },
                        child: Text(isApplied ? "가입취소" : "가입신청")),
                  ],
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}
