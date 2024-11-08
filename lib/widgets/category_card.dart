// category_service.dart
import 'package:flutter/material.dart';

class CategoryService extends ChangeNotifier {
  List<String> categories = [];

  void addCategory(String category) {
    categories.add(category);
    notifyListeners();  // Notify listeners when data changes
  }

  void removeCategory(String category) {
    categories.remove(category);
    notifyListeners();  // Notify listeners when data changes
  }
}
