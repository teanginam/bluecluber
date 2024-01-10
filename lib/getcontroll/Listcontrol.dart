import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tttttt/datalist/club.dart' as datalist;

class getLisetcontrol extends GetxController {
  List<Map> allClubData = [];
  List<String> categories = datalist.categories;
  final categoryData = [];

  Future fetchAllClubData() async {
    for (String category in categories) {
      List<Map> categoryClubData = [];
      final snapshot =
          await FirebaseFirestore.instance.collectionGroup(category).get();
      final categoryDocs = snapshot.docs;

      for (var clubDoc in categoryDocs) {
        categoryClubData.add({
          'name': clubDoc['name'],
          'information': clubDoc['information'],
          'introduction': clubDoc['introduction'],
          'tag': clubDoc['tag'],
          'members': clubDoc['members'],
          'path': 'clubs/8VKWlkDX4wmGnrjAI4q9/$category/${clubDoc.id}',
        });
      }
      // 카테고리별로
      allClubData.add({category: categoryClubData});
      for (int i = 0; i < categories.length; i++) {
        for (int j = 0; i < categories.length; j++) {
          categoryData.add(allClubData[i][categories[j]]);
          print(categoryData);
        }
      }
    }
    for (int i = 0; i < categories.length; i++) {
      for (int j = 0; i < categories.length; j++) {
        categoryData.add(allClubData[i][categories[j]]);
        print(categoryData);
      }
    }
  }
}
