import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/material_white.dart';
import 'package:make_feed_screen/home_page.dart';
import 'package:make_feed_screen/models/firebase_auth_state.dart';
import 'package:make_feed_screen/models/firestore/user_model.dart';
import 'package:make_feed_screen/models/firestore/user_model_state.dart';
import 'package:make_feed_screen/repo/user_network_repository.dart';
import 'package:make_feed_screen/screens/auth_screen.dart';
import 'package:make_feed_screen/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget? _currentWidget;
  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  UserModelState _userModelState = UserModelState();

  @override
  Widget build(BuildContext context) {
    _firebaseAuthState.watchAuthChange();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseAuthState>.value(value: _firebaseAuthState),
        // ChangeNotifierProvider<UserModelState>(create: (_) => UserModelState(),),
        ChangeNotifierProvider<UserModelState>.value(value: _userModelState),
        ],
      child: MaterialApp(
        home: Consumer<FirebaseAuthState>(builder: (context, firebaseAuthState, child) {
          switch (firebaseAuthState.firebaseAuthStatus) {
            case FirebaseAuthStatus.signout:
              _clearUserModel(context);
              _currentWidget = AuthScreen();
              break;
            case FirebaseAuthStatus.signin:
              _initUserModel(firebaseAuthState, context, _userModelState);
              _currentWidget = HomePage();
              break;
            default :
              // _clearUserModel(context);
              // _initUserModel(firebaseAuthState, context, _userModelState);
              _currentWidget = MyProgressIndicator();
              break;
          }

          return AnimatedSwitcher(
            duration: Duration(milliseconds: 1000),
            child: _currentWidget,
          );

        },),
        theme: ThemeData(primarySwatch: white),
      ),
    );
  }

  void _initUserModel(FirebaseAuthState firebaseAuthState, BuildContext context, UserModelState userModelState) {

    ///************************************** 기존 code **************************************///
    // UserModelState userModelState = Provider.of<UserModelState>(context);
    //
    // userModelState.currentStreamSub =
    //     userNetworkRepository.getUserModelStream(firebaseAuthState.firebaseUser!.uid)
    // .listen((user) { userModelState.userModel = user; });
    ///**************************************************************************************///

    ///************************************** Debug 성공 code **************************************///
    userModelState.currentStreamSub = userNetworkRepository.getUserModelStream(firebaseAuthState.firebaseUser!.uid).listen((user) {
      userModelState.userModel = user;
    });
    ///*******************************************************************************************///

    // Provider.of<UserModelState>(context).currentStreamSub =
    // userNetworkRepository.getUserModelStream(firebaseAuthState.firebaseUser!.uid).listen((user) {
    //   Provider.of<UserModelState>(context, listen: false).userModel=user;
    // });
  }

  void _clearUserModel(BuildContext context) {
    UserModelState userModelState = Provider.of<UserModelState>(context, listen: false);
    userModelState.clear();
  }

}
