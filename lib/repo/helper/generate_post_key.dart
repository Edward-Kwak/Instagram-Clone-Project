import 'package:make_feed_screen/models/firestore/user_model.dart';

String getNewPostKey(UserModel userModel) {
  return "${DateTime.now().millisecondsSinceEpoch}_${userModel.userKey}";
}

