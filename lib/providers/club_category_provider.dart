import 'package:flutter/material.dart';

class ClubCategoryProvider with ChangeNotifier {
  String _selectedCategory = '전체';
  String get selectedCategory => _selectedCategory;

  List<String> categories = ['전체', '체육1', '체육2', '문화1', '문화2', '교양', '봉사', '학술', '종교'];

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setCategory(String category, int index) {
    _selectedCategory = category;
    _selectedIndex = index;
    notifyListeners();
  }
  }
