import 'package:flutter_clb_tinhban_ui_app/provider/authentication_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock/firebase_mock.dart';

void main() {
  group('AuthenticationProvider', () {
    //Mock and inject the basic dependencies in the AuthenticationProvider
    FirebaseAuthMock firebaseAuth = FirebaseAuthMock();
    GoogleSignInMock googleSignIn = GoogleSignInMock();
    AuthenticationProvider authenticationProvider = AuthenticationProvider(
        fireBaseAuth: firebaseAuth, googleSignIn: googleSignIn);

    //Mock rest of the objects needed to replicate the AuthenticationProvider functions

    final GoogleSignInAccountMock googleSignInAccountMock =
        GoogleSignInAccountMock();
    final GoogleSignInAuthenticationMock googleSignInAuthenticationMock =
        GoogleSignInAuthenticationMock();
    final FirebaseUserMock firebaseUserMock = FirebaseUserMock();
    test('SignIn with google return Firebase user', () async {
      //mock the method calls
      when(googleSignIn.signIn()).thenAnswer((_) =>
          Future<GoogleSignInAccountMock>.value(googleSignInAccountMock));
      when(googleSignInAccountMock.authentication).thenAnswer((_) =>
          Future<GoogleSignInAuthenticationMock>.value(
              googleSignInAuthenticationMock));

      when(firebaseAuth.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUserMock));
      //call the method and expect the Firebase user as return
      expect(await authenticationProvider.signInWithGoogle(), firebaseUserMock);
      verify(googleSignIn.signIn()).called(1);
      verify(googleSignInAccountMock.authentication).called(1);
    });
    test('getCurrentUser return user', () async {
      when(firebaseAuth.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUserMock));
      expect(await authenticationProvider.getCurrentUser(), firebaseUserMock);
    });
    test(' is loggedIn return true  only when FirebaseAuth has a user',
        () async {
      when(firebaseAuth.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUserMock));
      expect(await authenticationProvider.isLoggedIn(), true);
      when(firebaseAuth.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(null));
      expect(await authenticationProvider.isLoggedIn(), false);
    });
  });
}
