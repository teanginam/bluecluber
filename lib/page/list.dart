
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tttttt/getcontroll/Listcontrol.dart';
import 'package:tttttt/jeahyeon/jhcode/search_page.dart';
import 'package:tttttt/datalist/club.dart' as datalist;

class ListPage extends StatefulWidget {

  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // List<Map> allClubData = [];
  bool isLoading = true;
  // 리스트 불러오기
  List<String> categories = datalist.categories;
  int _selectedCategoryIndex = 0;

  @override
  @override
  Widget build(BuildContext context) {
    // Get.put(getLisetcontrol());
    return GetBuilder<getLisetcontrol>(
        init: getLisetcontrol(),
        builder: (getLisetcontrol controller) {
          // void initState() {
          //   super.initState();
          //   _selectedCategoryIndex = widget._selectedCategoryIndex;
          //   controller.fetchAllClubData();
          // }

          Widget buildList(int categoryIndex, String category) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category != '전체')
                    Text(
                      category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  if (category != '전체')
                    const SizedBox(
                      height: 8,
                    ),
                  ListView.builder(
                      key: UniqueKey(),
                      controller: ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      itemCount: controller.categoryData.length,
                      itemBuilder: (context, index) {
                        final club = controller.categoryData[index];

                        return Column(
                          children: [
                            Container(
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
                                  leading: const FlutterLogo(
                                    size: 45,
                                  ),
                                  title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          club['name'],
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Text(
                                          club['information'],
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "동아리원: ${club['members'].length}명",
                                          style: const TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ]),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          club['introduction'],
                                          style: const TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        // 동아리 상세페이지 이동
                                        GestureDetector(
                                          onTap: () {
                                            // Get.to(
                                            //   const ClubPage(),
                                            //   arguments: club,
                                            // );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Center(
                                              child: Text(
                                                "${club['name']}(으)로 이동",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        );
                      }),
                ],
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.blue[700],
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    // 동아리 목록 , 검색바
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 32.0),
                            child: Text(
                              "동아리 목록",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.to(
                              const SearchPage(),
                              arguments: controller.allClubData,
                            );
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),

                    // 동아리  카테고리------------------------------------------
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          bool isAll = index == 0;
                          bool isSelected = _selectedCategoryIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: isAll ? 16.0 : 8.0, right: 8.0),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.grey : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  categories[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),

                    if (!isLoading)
                      // 전체버튼 누르면 모든 리스트 생성
                      if (_selectedCategoryIndex == 0)
                        for (int i = 0; i < categories.length; i++)
                          buildList(i, categories[i])
                      // 카테고리별로 선택하면 리스트 생성
                      else
                        for (int i = 0; i < categories.length; i++)
                          if (_selectedCategoryIndex == i)
                            buildList(i, categories[i])
                  ],
                ),
              ),
            ),
          );
        });
  }

// 카테고리별로 동아리 리스트 만들기
}
