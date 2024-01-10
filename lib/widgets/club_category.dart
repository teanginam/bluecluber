import 'package:flutter/material.dart';
import 'package:tttttt/providers/club_category_provider.dart';

class ClubCategory extends StatelessWidget {
  const ClubCategory({
    super.key,
    required this.categoryProvider,
  });

  final ClubCategoryProvider categoryProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[700],
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryProvider.categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              categoryProvider.setCategory(
                  categoryProvider.categories[index], index);
            },
            child: Container(
              width: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: categoryProvider.selectedIndex == index
                    ? Colors.blue[900]
                    : Colors.blue[700],
                borderRadius: BorderRadius.circular(2),
              ),
              child: Center(
                child: Text(
                  categoryProvider.categories[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: categoryProvider.selectedIndex == index
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
