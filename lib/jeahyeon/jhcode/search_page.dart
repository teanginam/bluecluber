import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tttttt/datalist/club.dart' as datalist;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

// 검색페이지
class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> allClubs = [];

  final allClubData = Get.arguments;
  List<String> categories = datalist.categories;
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";
  bool visi = false;

  _SearchPageState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }
  void allList() {
    allClubs = [];
    for (int categoryIndex = 0;
        categoryIndex < categories.length;
        categoryIndex++) {
      final category = categories[categoryIndex];
      final categoryData = allClubData[categoryIndex][category];

      final filteredClubs = categoryData.where((club) {
        final nameContainsText =
            club['name'].toString().contains(_searchText.toUpperCase());
        final infoContainsText =
            club['information'].toString().contains(_searchText.toUpperCase());
        final tagContainsText = club['tag'].contains(_searchText.toUpperCase());
        return nameContainsText || infoContainsText || tagContainsText;
      }).toList();

      final List<Map<String, dynamic>> typedFilteredClubs = filteredClubs
          .map<Map<String, dynamic>>((club) => Map<String, dynamic>.from(club))
          .toList();
      allClubs.addAll(typedFilteredClubs);
      allClubs.sort((a, b) => a['name'].compareTo(b['name']));
    }
  }

//태그 위젯 만들기
  Widget _buildTag(String tag) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _filter.text = tag;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.grey),
            child: Center(
              child: Text(
                "# $tag",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Widget _showRandomClubs() {
    // allClubs 리스트가 4개 이상의 동아리를 가지고 있다고 가정합니다.
    List<Map<String, dynamic>> randomClubs = [];
    Random random = Random();

    // 중복없이 4개의 랜덤한 인덱스 선택
    List<int> selectedIndexes = [];
    while (selectedIndexes.length < 4) {
      int index = random.nextInt(allClubs.length);
      if (!selectedIndexes.contains(index)) {
        selectedIndexes.add(index);
        randomClubs.add(allClubs[index]);
      }
    }

    return Column(
      children: [
        const Text(
          "이런 동아리는 어때요?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (final club in randomClubs)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Theme(
                // divider 없애기
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  textColor: Colors.black,
                  tilePadding: const EdgeInsets.all(8),
                  childrenPadding: const EdgeInsets.all(8),
                  // leading: club['imgUrl'] == ''
                  //     ? const CircleAvatar(
                  //         radius: 30,
                  //       )
                  //     : CircleAvatar(
                  //         radius: 30,
                  //         backgroundImage: NetworkImage(
                  //           club['imgUrl']!,
                  //         ),
                  //       ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        club['name'],
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        club['information'],
                        style: const TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "동아리원: ${club['members'].length}명",
                        style: const TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club['introduction'],
                          style: const TextStyle(fontSize: 10.0),
                        ),
                        const SizedBox(height: 8),
                        // 동아리 상세페이지 이동
                        GestureDetector(
                          onTap: () {
                            // Get.to(
                            //   const ClubPage(),
                            //   arguments: club,
                            // );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                "${club['name']}(으)로 이동",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  //카테고리중 동아리 데이터 받기 ----------------------------------------------------------------------------
  // Widget buildList(int categoryIndex, String category) {
  //   final categoryData = allClubData[categoryIndex][category];
  //   return ListView.builder(
  //       key: UniqueKey(),
  //       controller: ScrollController(keepScrollOffset: false),
  //       shrinkWrap: true,
  //       itemCount: categoryData.length,
  //       itemBuilder: (context, index) {
  //         final club = categoryData[index];
  //         if (club['name'].toString().contains(_searchText.toUpperCase()) ||
  //             club['information']
  //                 .toString()
  //                 .contains(_searchText.toUpperCase()) ||
  //             club['tag'].contains(_searchText.toUpperCase())) {
  //           return Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Theme(
  //                     // divider 없애기
  //                     data: Theme.of(context).copyWith(
  //                       dividerColor: Colors.transparent,
  //                     ),
  //                     child: ExpansionTile(
  //                       textColor: Colors.black,
  //                       tilePadding: const EdgeInsets.all(8),
  //                       childrenPadding: const EdgeInsets.all(8),
  //                       leading: const FlutterLogo(
  //                         size: 45,
  //                       ),
  //                       title: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               club['name'],
  //                               style: const TextStyle(
  //                                   fontSize: 16.0,
  //                                   fontWeight: FontWeight.w900),
  //                             ),
  //                             Text(
  //                               club['information'],
  //                               style: const TextStyle(
  //                                   fontSize: 11.0,
  //                                   fontWeight: FontWeight.w600),
  //                             ),
  //                             const SizedBox(
  //                               height: 10,
  //                             ),
  //                             Text(
  //                               "동아리원: ${club['members'].length}명",
  //                               style: const TextStyle(
  //                                   fontSize: 10.0,
  //                                   fontWeight: FontWeight.w300),
  //                             ),
  //                           ]),
  //                       children: [
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               club['introduction'],
  //                               style: const TextStyle(
  //                                 fontSize: 10.0,
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 8,
  //                             ),
  //                             // 동아리 상세페이지 이동
  //                             GestureDetector(
  //                               onTap: () {
  //                                 Get.to(
  //                                   const ClubPage(),
  //                                   arguments: club,
  //                                 );
  //                               },
  //                               child: Container(
  //                                 margin:
  //                                     const EdgeInsets.symmetric(horizontal: 2),
  //                                 height: 40,
  //                                 decoration: BoxDecoration(
  //                                     color: Colors.blue,
  //                                     borderRadius:
  //                                         BorderRadius.circular(10.0)),
  //                                 child: Center(
  //                                   child: Text(
  //                                     "${club['name']}(으)로 이동",
  //                                     style:
  //                                         const TextStyle(color: Colors.white),
  //                                   ),
  //                                 ),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         } else {
  //           return Container();
  //         }
  //       });
  // }

// _searchResults 메서드
  Widget _searchResults(BuildContext context) {
    if (allClubs.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: ListView.builder(
          controller: ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          itemCount: allClubs.length,
          itemBuilder: (context, index) {
            final club = allClubs[index];
            return Container(
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: Column(
                children: [
                  const Divider(),
                  InkWell(
                    onTap: () {
                      // Get.to(
                      //   const ClubPage(),
                      //   arguments: club,
                      // );
                    },
                    child: Container(
                        child: Row(
                      children: [
                        club['imgUrl'] == ''
                            ? const CircleAvatar(
                                radius: 30,
                              )
                            : CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  club['imgUrl']!,
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  club['name'],
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                              Text(
                                club['information'],
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "동아리원: ${club['members'].length}명",
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {
      return Container(); // 검색 결과가 없을 경우
    }
  }

// 인기 검색어 위젯
  Widget _popularSearchesWidget() {
    List<String> popularSearches = [
      '봉사',
      '문화',
      '친목',
      '운동',
      '여행',
      '미술',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "인기 검색어",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popularSearches.map((searchQuery) {
            return GestureDetector(
              onTap: () {
                _filter.text = searchQuery;
                // addRecentSearch(searchQuery); // 최근 검색어 갱신
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300],
                ),
                child: Text(searchQuery),
              ),
            );
          }).toList(),
        ),
        const Divider(), // 구분선 추가
      ],
    );
  }

  Widget _unselecList(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        // height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              // const Text(
              //   "추천 태그",
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _buildTag('봉사'),
              //     _buildTag('문화'),
              //     _buildTag('친목'),
              //     _buildTag('운동'),
              //   ],
              // ),
              // const SizedBox(
              //   height: 50,
              // ),
              _popularSearchesWidget(),
              const SizedBox(
                height: 20,
              ),
              Expanded(child: SingleChildScrollView(child: _showRandomClubs()))
              // 인기 검색어 ------------------------------------
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     const Row(
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: [
              //         Text(
              //           "인기 검색어",
              //           style: TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         SizedBox(
              //           width: 8,
              //         ),
              //         Text(
              //           "01.11 PM 02:03 기준",
              //           style: TextStyle(fontSize: 10.0),
              //         ),
              //       ],
              //     ),
              //     GestureDetector(
              //         onTap: () {},
              //         child: const Text(
              //           "더보기",
              //           style: TextStyle(fontSize: 10.0),
              //         ))
              //   ],
              // ),

              // const SizedBox(
              //   height: 10,
              // ),
              // const Row(
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text("1  중앙동아리"),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Text("2  인싸"),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Text("3  동아리 ")
              //       ],
              //     ),
              //     SizedBox(
              //       width: 100,
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text("4  중앙동아리"),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Text("5  인싸"),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Text("6  동아리 ")
              //       ],
              //     )
              //   ],
              // ),
              // const SizedBox(
              //   height: 50,
              // ),
              // const Text(
              //   "최근 검색한 동아리",
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // SizedBox(
              //   height: 80,
              //   child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: 2,
              //       itemBuilder: (context, index) {
              //         return Row(
              //           children: [
              //             Container(
              //               width: 180,
              //               padding: const EdgeInsets.all(8),
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(6),
              //                 color: Colors.grey[300],
              //               ),
              //               child: const Row(
              //                 children: [
              //                   FlutterLogo(
              //                     size: 40,
              //                   ),
              //                   SizedBox(
              //                     width: 10,
              //                   ),
              //                   Column(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             "동아리 이름",
              //                             style: TextStyle(
              //                                 fontSize: 15.0,
              //                                 fontWeight: FontWeight.w900),
              //                           ),
              //                           Text("상세정보",
              //                               style: TextStyle(
              //                                   fontSize: 11.0,
              //                                   fontWeight: FontWeight.w600)),
              //                         ],
              //                       ),
              //                       Text(
              //                         "동아리원 00명",
              //                         style: TextStyle(
              //                             fontSize: 10.0,
              //                             fontWeight: FontWeight.w300),
              //                       ),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             const SizedBox(
              //               width: 10,
              //             ),
              //           ],
              //         );
              //       }),
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    allList();
    return Scaffold(
      body: Container(
        color: Colors.blue[700],
        height: double.infinity,
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 46.0),
                      child: Text(
                        "검색",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      "전체보기",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),

              // 동아리 검색 ----------------------------------------
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
                child: SizedBox(
                  height: 45,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          focusNode: focusNode,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          autofocus: true,
                          controller: _filter,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                            suffixIcon: focusNode.hasFocus
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _filter.clear();
                                        _searchText = "";
                                      });
                                    },
                                  )
                                : Container(),
                            hintText: '검색',
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                        ),
                      ),
                      // focusNode.hasFocus
                      // ? Expanded(
                      //     child: TextButton(
                      //       child: const Text('취소'),
                      //       onPressed: () {
                      //         setState(() {
                      //           _filter.clear();
                      //           _searchText = "";
                      //           focusNode.unfocus();
                      //         });
                      //       },
                      //     ),
                      //   )
                      // : Expanded(
                      //     flex: 0,
                      //     child: Container(),
                      //   )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_searchText == "")
                Expanded(
                  child: Column(
                    children: [_unselecList(context)],
                  ),
                )
              else
                Expanded(
                  child: Container(
                    color: const Color.fromARGB(255, 246, 246, 246),
                    child: Container(
                        child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: _searchResults(context),
                            ))),
                  ),
                ),
              if (categories.isEmpty) const Text("data")
            ],
            // 전체버튼 누르면 모든 리스트 생성
          ),
        ),
      ),
    );
  }
}