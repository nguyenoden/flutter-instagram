import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/base_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final FirebaseAuth fireBaseAuth;
  final GoogleSignIn googleSignIn;
  final FacebookLogin facebookLogin;

  AuthenticationProvider(
      {FirebaseAuth fireBaseAuth,
      GoogleSignIn googleSignIn,
      FacebookLogin facebookLogin})
      : fireBaseAuth = fireBaseAuth ?? FirebaseAuth.instance,
        googleSignIn = googleSignIn ?? GoogleSignIn(),
        facebookLogin = facebookLogin ?? FacebookLogin();

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return await fireBaseAuth.currentUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await fireBaseAuth.currentUser();

    return user != null;
  }

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    // TODO: implement signInWithGoogle
    //show the goggle login prompt
    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await account.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        //retreive the authentication credentials
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    //sign in to firebase using the generated credentials
    await fireBaseAuth.signInWithCredential(authCredential);
    FirebaseUser firebaseUser = await fireBaseAuth.currentUser();
    await ShareObjects.prefs.setString(Constants.sessionUid, firebaseUser.uid);
    return firebaseUser;
  }

  @override
  Future<void> signOut() async {
    // TODO: implement signOut
    // SignOut khỏi Firebase Auth
    await fireBaseAuth.signOut();
    // Logout google
    await googleSignIn.signOut();
    // Logout facebook
    await facebookLogin.logOut();

    //await Future.wait([fireBaseAuth.signOut(), googleSignIn.signOut(),facebookLogin.logOut()]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<FirebaseUser> signInWithFacebook() async {
    // Gọi hàm LogIn() với giá trị truyền vào là một mảng permission
    // Ở đây mình truyền vào cho nó quền xem email
    final result = await facebookLogin.logIn(['email']);
    // Kiểm tra nếu login thành công thì thực hiện login Firebase
    // (theo mình thì cách này đơn giản hơn là dùng đường dẫn
    // hơn nữa cũng đồng bộ với hệ sinh thái Firebase, tích hợp được
    // nhiều loại Auth
    if (result.status == FacebookLoginStatus.loggedIn) {
      final authCredential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
      // Lấy thông tin User qua credential có giá trị token đã đăng nhập
      await fireBaseAuth.signInWithCredential(authCredential);
    }
    FirebaseUser firebaseUser = await fireBaseAuth.currentUser();
    print(firebaseUser.uid);

    await ShareObjects.prefs.setString(Constants.sessionUid, firebaseUser.uid);
    print(
        'Session UID Facebook ${ShareObjects.prefs.getString(Constants.sessionUid)}');

    return firebaseUser;
  }
}
