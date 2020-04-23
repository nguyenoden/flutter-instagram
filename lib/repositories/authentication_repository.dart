import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/authentication_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/base_provider.dart';

import 'base_repository.dart';

class AuthenticationRepository extends BaseRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  Future<FirebaseUser> signInWithGoogle() =>
      authenticationProvider.signInWithGoogle();

  Future<FirebaseUser> signInWithFacebook() =>
      authenticationProvider.signInWithFacebook();

  Future<void> signOut() => authenticationProvider.signOut();

  Future<FirebaseUser> getCurrent() => authenticationProvider.getCurrentUser();

  Future<bool> isLoggedIn() => authenticationProvider.isLoggedIn();

  @override
  void dispose() {
    authenticationProvider.dispose();
  }
}
