import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/providers/club_category_provider.dart';
import 'package:tttttt/providers/club_provider.dart';
import 'package:tttttt/widgets/club_category.dart';
import 'package:tttttt/widgets/club_list.dart';

class ListPage extends StatefulWidget {
  final int _selectedCategoryIndex;

  const ListPage(this._selectedCategoryIndex, {Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<ClubCategoryProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: Stack(
        children: [
          Container(
            color: Colors.blue[700],
            height: 100,
          ),
          SafeArea(
            child: Column(
              children: [
                // 동아리 목록 , 검색바
                Container(
                  color: Colors.blue[700],
                  child: Row(
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
                          //  Get.to(
                          //           const SearchPage(),
                          //         );
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ),

                // 동아리  카테고리------------------------------------------
                ClubCategory(categoryProvider: categoryProvider),

                // 동아리 리스트
                FutureBuilder(
                    future: Provider.of<ClubProvider>(context, listen: false)
                        .fetchClubList(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Consumer<ClubProvider>(
                              builder: (context, provider, _) => ClubList(
                                    clubList: provider.clubList,
                                    category: categoryProvider.selectedCategory,
                                  ));
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
