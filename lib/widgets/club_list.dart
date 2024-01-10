import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tttttt/pages/club_detail_page.dart';


class ClubList extends StatelessWidget {
  const ClubList({
    super.key, required this.clubList, required this.category
  });

final List clubList;
final String category;


  @override
  Widget build(BuildContext context) {
    List selectedList = [];
    

    
     if (category == '전체') {
      selectedList = clubList;
    } else {
      selectedList = clubList.where((club) => club.category == category).toList();
      }
    return Expanded(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Color.fromARGB(255, 246, 246, 246),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  ListView.builder(
                            key: UniqueKey(),
                            controller: ScrollController(keepScrollOffset: false),
                            shrinkWrap: true,
                            itemCount: selectedList.length,
                            itemBuilder: (context, index) {                    
                              final club = selectedList[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClubDetailPage(id : club.id)));
                                },
                                child: Column(
                                  children: [
                                    const Divider(),
                                    Container(
                                        child: Row(
                                      children: [ 
                                          // imgUrl 필드가 없다면
                                            if(club.imgUrl.isEmpty)
                                            // 없을때 클로버 아이콘
                                            Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.blue),
                                              ) 
                                              else
                                            // 캐시 네트워크 이미지
                                             ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10000.0),
                                                child: CachedNetworkImage(
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  key: UniqueKey(),
                                                  imageUrl: club.imgUrl,
                                                  placeholder: (context, url) => SizedBox(),
                                                  errorWidget: (context, url, error) =>
                                                      Icon(Icons.error),
                                                ),
                                              ),
                                            
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10, left: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text(
                                                  club.name,
                                                  style: const TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w900),
                                                ),
                                              ),
                                              Text(
                                                club.information,
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                "동아리원: ${club.member.length}명",
                                                style: const TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                                  ],
                                ),
                              );
                            }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
