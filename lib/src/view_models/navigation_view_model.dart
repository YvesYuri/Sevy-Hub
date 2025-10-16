import 'package:flutter/material.dart';
import 'package:sevyhub/src/models/user_model.dart';
import 'package:sevyhub/src/services/authentication_service.dart';

class NavigationViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;

  NavigationViewModel(this._authenticationService);

  bool _isExpanded = true;
  int _selectedIndex = 0;

  bool get isExpanded => _isExpanded;
  int get selectedIndex => _selectedIndex;
  UserModel? get currentUser => _authenticationService.currentUser;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void expandMenuNavigation() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authenticationService.signOut();
  }

  String getUserInitials() {
    if (currentUser == null || currentUser!.fullName!.isEmpty) {
      return 'G';
    }
    List<String> names = currentUser!.fullName!.split(' ');
    String initials = names
        .map((name) => name.isNotEmpty ? name[0] : '')
        .join();
    return initials.toUpperCase();
  }

  String getUserDisplayName() {
    if (currentUser == null || currentUser!.fullName!.isEmpty) {
      return 'Guest';
    }
    return '${currentUser!.fullName!.split(' ').first} ${currentUser!.fullName!.split(' ').last}';
  }
}
