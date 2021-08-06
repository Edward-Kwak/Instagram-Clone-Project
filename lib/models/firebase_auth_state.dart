import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:make_feed_screen/repo/user_network_repository.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:make_feed_screen/utils/simple_snackbar.dart';

enum FirebaseAuthStatus {
  signout, progress, signin
}

class FirebaseAuthState extends ChangeNotifier {
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.progress;
  User? _firebaseUser;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FacebookLogin? _facebookLogin;

  void watchAuthChange() {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user == null && _firebaseUser == null) {
        changeFirebaseAuthStatus();
        return;
      }
      else if (user != _firebaseUser){
        _firebaseUser = user;
        changeFirebaseAuthStatus();
      }
    });
  }

  void registerUser(BuildContext context, {required String email, required String password}) async {

    // changeFirebaseAuthStatus(FirebaseAuthStatus.progress);

    UserCredential userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).catchError((error) {
      print('on registerUser Method, error !');
      String errMsg = error.toString();
      // String snackBarMsg = "Error !";

      print(errMsg);

      if(errMsg.contains('invalid-email'))  SimpleSnackBar(context, '올바르지 않은 이메일 주소 형식입니다.\n이메일 주소를 다시 확인하세요.');
      else if (errMsg.contains('email-already-in-use')) SimpleSnackBar(context, '이미 사용중인 이메일 주소입니다.');
      else if (errMsg.contains('operation-not-allowed'))  SimpleSnackBar(context, '승인되지 않은 이메일 주소입니다.\n관리자에게 문의하세요.');
      else if (errMsg.contains('weak-password'))  SimpleSnackBar(context, '비밀번호가 취약합니다.');
    });


    // User? user = userCred.user;
    _firebaseUser = userCred.user;

    if (_firebaseUser != null) {
      await userNetworkRepository.attemptCreateUser(context, userKey: _firebaseUser!.uid, email: _firebaseUser!.email!);
    }
    else {
      print('registerUser Method 의 else 문.');
      // SimpleSnackBar(context, 'Error While Registering. Try Again Later.\n-Edward');
    }

  }

  void logIn(BuildContext context, {required String email, required String password}) async {

    // changeFirebaseAuthStatus(FirebaseAuthStatus.progress);

    UserCredential userCred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    ).catchError((error){

      print('on log In Method, error !');
      String errMsg = error.toString();
      // String snackBarMsg = "Error !";

      print(errMsg);

      if(errMsg.contains('invalid-email'))  SimpleSnackBar(context, '올바르지 않은 이메일 주소 형식입니다.\n이메일 주소를 다시 확인하세요.');
      else if (errMsg.contains('user-disabled')) SimpleSnackBar(context, '관리자에 의해 허용되지 않은 계정입니다.\n관리자에게 문의하세요.');
      else if (errMsg.contains('user-not-found'))  SimpleSnackBar(context, '등록되지 않은 이메일 주소입니다.\n');
      else if (errMsg.contains('wrong-password'))  SimpleSnackBar(context, '잘못된 비밀번호 입니다.');

    });

    _firebaseUser = userCred.user;

    if (_firebaseUser== null) {
      SimpleSnackBar(context, 'Error While Login. Try Again Later.\n-Edward');
    }

    // await userNetworkRepository.attemptCreateUser(context, userKey: _firebaseUser!.uid, email: _firebaseUser!.email!);


  }


  void logInWithFacebook (BuildContext context) async {

    // changeFirebaseAuthStatus(FirebaseAuthStatus.progress);

    if (_facebookLogin == null) _facebookLogin = FacebookLogin();

    final result = await _facebookLogin!.logIn(permissions: [FacebookPermission.email]);

    switch (result.status) {
      case FacebookLoginStatus.success:
        _handleFacebookTokenWithFirebase(context, result.accessToken!.token);
        break;
      case FacebookLoginStatus.cancel:
        SimpleSnackBar(context, '페이스북으로 로그인 취소됨.');
        break;
      case FacebookLoginStatus.error:
        SimpleSnackBar(context, '페이스북으로 로그인 중 에러 발생.');
        await _facebookLogin!.logOut();
        break;
    }
  }

  void _handleFacebookTokenWithFirebase(BuildContext context, String token) async {
    final AuthCredential facebookCredential = FacebookAuthProvider.credential(token);
    final UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookCredential);

    // final User? user = userCredential.user;
    _firebaseUser = userCredential.user;


    if (_firebaseUser == null) {
      SimpleSnackBar(context, '페이스북으로부터 로그인 정보 받아오기 실패. 다시 시도해보세요.');
    }
    else {
      // _firebaseUser = user;
      await userNetworkRepository.attemptCreateUser(context, userKey: _firebaseUser!.uid, email: _firebaseUser!.email!);
    }

    notifyListeners();
  }

  void signOut() async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);

    _firebaseAuthStatus = FirebaseAuthStatus.signout;

    if (_firebaseUser != null) {

      if (_facebookLogin!= null) {
        if (await _facebookLogin!.isLoggedIn) await _facebookLogin!.logOut();
      }
      _firebaseUser = null;

      await _firebaseAuth.signOut();
    }

    notifyListeners();
  }

  void changeFirebaseAuthStatus([FirebaseAuthStatus? firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      _firebaseAuthStatus = firebaseAuthStatus;
    }
    else {
      if (_firebaseUser != null) {
        _firebaseAuthStatus = FirebaseAuthStatus.signin;
      } else {
        _firebaseAuthStatus = FirebaseAuthStatus.signout;
      }
    }

    notifyListeners();
  }

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;
  FirebaseAuth get firebaseAuth => _firebaseAuth;
  User? get firebaseUser => _firebaseUser;

}