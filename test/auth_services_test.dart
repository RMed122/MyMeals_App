import 'package:flutter_test/flutter_test.dart';
import 'package:mymeals/services/auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mymeals/model/user_model.dart';

void main() {
  group('Auth Services', () {
    test("Auth with email and password", () async {
      final user = MockUser(
        isAnonymous: false,
        uid: '001',
        email: 'test@test.com',
        displayName: 'Doe',
      );
      final googleSignIn = MockGoogleSignIn();
      final auth = MockFirebaseAuth(mockUser: user);
      Auth authInst =
          Auth(testMode: true, mockAuth: auth, mockGoogleSignIn: googleSignIn);
      User? signedUser =
          await authInst.handleSignInEmail('bob@somedomain.com', "password");
      expect(signedUser!.email, "test@test.com");
    });

    test("Signup with email and password", () async {
      final auth = MockFirebaseAuth();
      final googleSignIn = MockGoogleSignIn();
      Auth authInst =
          Auth(testMode: true, mockAuth: auth, mockGoogleSignIn: googleSignIn);
      User? signedUser = await authInst.handleSignUp("test@test.it", "pass");
      expect(signedUser!.email, "test@test.it");
    });

    test("Auth with Google Sign In", () async {
      final user = MockUser(
        isAnonymous: false,
        uid: '001',
        email: 'test@test.com',
        displayName: 'Doe',
      );
      final googleSignIn = MockGoogleSignIn();
      final auth = MockFirebaseAuth(mockUser: user);
      Auth authInst =
          Auth(testMode: true, mockAuth: auth, mockGoogleSignIn: googleSignIn);
      dynamic signedUser = await authInst.signInwithGoogle();
      expect(signedUser.user.email, "test@test.com");
    });

    test("Get signed in user", () async {
      final user = MockUser(
        isAnonymous: false,
        uid: '001',
        email: 'test@test.com',
        displayName: 'Doe',
      );
      final googleSignIn = MockGoogleSignIn();
      final auth = MockFirebaseAuth(mockUser: user);
      Auth authInst =
          Auth(testMode: true, mockAuth: auth, mockGoogleSignIn: googleSignIn);
      await authInst.signInwithGoogle();
      dynamic signedUser = authInst.user;
      expect(signedUser, isNotNull);
    });

    test("Log Out", () async {
      final user = MockUser(
        isAnonymous: false,
        uid: '001',
        email: 'test@test.com',
        displayName: 'Doe',
      );
      final googleSignIn = MockGoogleSignIn();
      final auth = MockFirebaseAuth(mockUser: user);
      Auth authInst =
          Auth(testMode: true, mockAuth: auth, mockGoogleSignIn: googleSignIn);
      await authInst.signInwithGoogle();
      await authInst.logout();
    });
  });
}
