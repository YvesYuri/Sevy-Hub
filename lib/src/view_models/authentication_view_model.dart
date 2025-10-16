import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sevyhub/src/models/user_model.dart';
import 'package:sevyhub/src/services/authentication_service.dart';
import 'package:sevyhub/src/utils/exception_util.dart';

enum AuthenticationState {
  idle,
  loadingSignIn,
  loadingSignUp,
  loadingForgotPassword,
  loadingGoogle,
  success,
  error,
}

class AuthenticationViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;

  AuthenticationState _state = AuthenticationState.idle;
  String? _errorMessage;
  bool _isPasswordVisible = false;
  bool _showSignUp = false;
  ValueNotifier<bool> _isLoggedInNotifier = ValueNotifier(false);

  AuthenticationState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get showSignUp => _showSignUp;
  ValueNotifier<bool> get isLoggedIn => _isLoggedInNotifier;
  UserModel? get currentUser => _authenticationService.currentUser;

  AuthenticationViewModel(this._authenticationService) {
    _authenticationService.authStateChanges.listen((UserModel? user) {
      _errorMessage = null;
      _isLoggedInNotifier.value = user != null;
    });
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleSignUp(bool value) {
    _showSignUp = value;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _state = AuthenticationState.loadingSignIn;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    if (validateSignForm(email, password)) {
      try {
        await _authenticationService.signInUser(email, password);
        _state = AuthenticationState.success;
        notifyListeners();
      } on AppException catch (e) {
        _errorMessage = e.message;
        _state = AuthenticationState.error;
        notifyListeners();
        _state = AuthenticationState.idle;
      }
    }
  }

  Future<void> signUp(
    String fullName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    _state = AuthenticationState.loadingSignUp;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    if (validateSignUpForm(fullName, email, password, confirmPassword)) {
      try {
        await _authenticationService.signUpUser(fullName, email, password);
        _state = AuthenticationState.success;
        notifyListeners();
      } on AppException catch (e) {
        _errorMessage = e.message;
        _state = AuthenticationState.error;
        notifyListeners();
        _state = AuthenticationState.idle;
      }
    }
  }

  Future<void> signInWithGoogle() async {
    _state = AuthenticationState.loadingGoogle;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    try {
      await _authenticationService.signInWithGoogle();
      _state = AuthenticationState.success;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
    }
  }

  Future<void> forgotPassword(String email) async {
    _state = AuthenticationState.loadingForgotPassword;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    if (validateForgotPasswordForm(email)) {
      try {
        await _authenticationService.sendPasswordResetEmail(email);
        _state = AuthenticationState.success;
      } on AppException catch (e) {
        _errorMessage = e.message;
        _state = AuthenticationState.error;
        notifyListeners();
        _state = AuthenticationState.idle;
      }
    }
  }

  bool validateSignForm(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email and password cannot be empty';
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
      return false;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      _errorMessage = 'Invalid email format';
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
      return false;
    }
    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters long';
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
      return false;
    }
    _errorMessage = null;
    _state = AuthenticationState.success;
    return true;
  }

  bool validateSignUpForm(
    String fullName,
    String email,
    String password,
    String confirmPassword,
  ) {
    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _errorMessage = 'All fields are required';
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
      return false;
    }
    if (fullName.length < 4) {
      _errorMessage = 'Full name must be at least 4 characters long';
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
      return false;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      _errorMessage = 'Invalid email format';
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
      return false;
    }
    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters long';
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
      return false;
    }
    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match';
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
      return false;
    }
    _errorMessage = null;
    _state = AuthenticationState.success;
    return true;
  }

  bool validateForgotPasswordForm(String email) {
    if (email.isEmpty) {
      _errorMessage = 'Email cannot be empty';
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
      return false;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      _errorMessage = 'Invalid email format';
      _state = AuthenticationState.error;
      notifyListeners();
      _state = AuthenticationState.idle;
      return false;
    }
    _errorMessage = null;
    _state = AuthenticationState.success;
    return true;
  }
}
