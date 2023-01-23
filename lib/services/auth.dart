import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mymeals/model/user_model.dart';

class Auth {
  final bool testMode;
  final dynamic mockAuth;
  final dynamic mockGoogleSignIn;
  late auth.FirebaseAuth _firebaseAuth;
  late GoogleSignIn _googleSignIn;
  Auth(
      {this.testMode = false,
      this.mockAuth = false,
      this.mockGoogleSignIn = false}) {
    if (!testMode) {
      _firebaseAuth = auth.FirebaseAuth.instance;
      _googleSignIn = GoogleSignIn();
    } else {
      _firebaseAuth = mockAuth;
      _googleSignIn = mockGoogleSignIn;
    }
  }

  User? _firebaseUser(auth.User? user) {
    if (user == null) {
      return null;
    }

    return User(user.uid, user.email);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_firebaseUser);
  }

  Future<User?> handleSignInEmail(String email, String password) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return _firebaseUser(result.user);
  }

  Future<User?> handleSignUp(String email, String password) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return _firebaseUser(result.user);
  }

  Future<dynamic> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } on auth.FirebaseAuthException catch (e) {
      return "Invalid";
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {}

    return await _firebaseAuth.signOut();
  }
}
