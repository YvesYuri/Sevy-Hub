import 'package:firebase_auth/firebase_auth.dart';
import 'package:sevyhub/src/models/user_model.dart';
import 'package:sevyhub/src/utils/exception_util.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel? get currentUser => _firebaseAuth.currentUser != null
      ? _convertFirebaseUserToUserModel(_firebaseAuth.currentUser!)
      : null;

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((User? firebaseUser) {
      return firebaseUser != null
          ? _convertFirebaseUserToUserModel(firebaseUser)
          : null;
    });
  }

  Future<UserModel?> signInUser(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user != null
          ? _convertFirebaseUserToUserModel(credential.user!)
          : null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw AppException('User not found');
        case 'wrong-password':
          throw AppException('Wrong password');
        case 'invalid-email':
          throw AppException('Invalid email');
        case 'user-disabled':
          throw AppException('User disabled');
        case 'too-many-requests':
          throw AppException(
            'Too many attempts. Please try again later',
          );
        default:
          throw AppException('Authentication error: ${e.message}');
      }
    } catch (e) {
      throw AppException('Unexpected error during authentication');
    }
  }

  Future<UserModel?> signUpUser(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(fullName);
      await credential.user?.sendEmailVerification();
      return credential.user != null
          ? _convertFirebaseUserToUserModel(credential.user!)
          : null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw AppException('Email already in use');
        case 'weak-password':
          throw AppException('Password is too weak');
        case 'invalid-email':
          throw AppException('Invalid email');
        default:
          throw AppException('Registration error: ${e.message}');
      }
    } catch (e) {
      throw AppException('Unexpected error during registration');
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      final UserCredential userCredential =
          await _firebaseAuth.signInWithProvider(googleProvider);

      if (userCredential.user == null) {
        throw AppException('Google sign-in failed');
      }

      return _convertFirebaseUserToUserModel(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AppException('Google sign-in error: ${e.message}');
    } catch (e) {
      throw AppException('Unexpected error during Google sign-in');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw AppException('User not found');
        case 'invalid-email':
          throw AppException('Invalid email');
        default:
          throw AppException('Error sending password reset email: ${e.message}');
      }
    } catch (e) {
      throw AppException('Unexpected error sending password reset email');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AppException('Error signing out');
    }
  }

  UserModel _convertFirebaseUserToUserModel(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      fullName: firebaseUser.displayName,
      email: firebaseUser.email,
      emailVerified: firebaseUser.emailVerified,
      lastSignInTime: firebaseUser.metadata.lastSignInTime,
      creationTime: firebaseUser.metadata.creationTime,
      photoUrl: firebaseUser.photoURL,
    );
  }
}
