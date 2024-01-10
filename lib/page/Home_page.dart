import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/%E1%84%92%E1%85%A9%E1%86%B7%20%E1%84%8B%E1%85%B1%E1%84%8C%E1%85%A6%E1%86%BA/dislpayclub.dart';
import 'package:tttttt/current_user.dart';
import 'package:tttttt/pages/list_page.dart';
import 'package:tttttt/providers/user_provider.dart';
import '../datalist/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../홈 위젯/list.dart';
import '../홈 위젯/bull.dart';
import '../datalist/club.dart' as datalist;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? hasclub;
  String? clubname;
  List? getListclub;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
        Provider.of<UserProvider>(context, listen: false).getCurrentUserData();
  }
  Widget Guestmode(String name) {
    String getname = name;

    return InkWell(
      onTap: () {
        Get.to(const ListPage(0));
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.225,
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            '$getname님의 현재 가입된 동아리 없습니다. \n \n < 동아리 가입하러 가기 >',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> categorieslist = datalist.categories;

    return StreamBuilder<DocumentSnapshot>(
      stream: CurrentUser.getDocRef().snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('error${snapshot.error}'),
          );
        }

        DocumentSnapshot<Object?> doc = snapshot.data!;
        clubname = null;
        // 정보 가져오기
        userData userdata = userData.fromSnapshot(doc);
        print(userdata);
        getListclub = userdata.membership;
        print("$getListclub 가입된 동아리 리스트");
        // if (userdata.membership?[0] != null) {

        // }
        if (userdata.membership == null || userdata.membership!.isEmpty) {
          print('없자나');
          clubname = null;
          // return const Icon(Icons.warning); // 경고 아이콘으로 대체
        } else {
          hasclub = userdata.membership?[0]['name'];
        }
        print(clubname);
        clubname = hasclub;
        print('이름은?? $clubname');

        return Scaffold(
          backgroundColor: Colors.blue[700],
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '국립 창원대학교 동아리',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     await viewModel.logout();
                              //     setState(() {});
                              //   },
                              //   child: const Text('Logout'),
                              // )
                            ],
                          ),
                        ),
                        //창원대학교 이름
                        // if(userData.('membership').orderBy('membership'))

                        if (clubname == null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Guestmode(userdata.name),
                          )
                        else
                          DisplayClub(
                            clubnames: getListclub!,
                            userdata: userdata,
                          )
                      ], //컬럼의 차일드
                    ),
                  ],
                ),
                dragg(categorieslist: categorieslist),
              ],
            ),
          ),
        );
      },
    );
  }
}

class dragg extends StatelessWidget {
  const dragg({
    super.key,
    required this.categorieslist,
  });

  final List<String> categorieslist;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.58,
      maxChildSize: 1,
      builder: (BuildContext context, scrollController) {
        return ListView(
          physics: const ClampingScrollPhysics(),
          controller: scrollController,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 246, 246, 246),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(23),
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '동아리 카테고리',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120, // 원하는 높이로 설정
                    child: ListView.builder(
                      itemCount: categorieslist.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return MyCircle(index);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 20, 0, 0),
                    child: Text(
                      '동아리 소식',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                    child: Container(
                      child: const NotificationGridView(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              color: const Color.fromARGB(255, 246, 246, 246),
            )
          ],
        );
      },
    );
  }
}
