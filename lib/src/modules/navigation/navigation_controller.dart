import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  bool isExpanded = true;

  void toggleNavigation() {
    isExpanded = !isExpanded;
    notifyListeners();
  }
}