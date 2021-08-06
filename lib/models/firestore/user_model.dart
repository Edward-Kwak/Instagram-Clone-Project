import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_feed_screen/constants/firestore_keys.dart';

class UserModel {
  final String userKey;
  final String profileImg;
  final String email;
  final List<dynamic> myPosts;
  final int followers;
  final List<dynamic> likedPosts;
  final String username;
  final List<dynamic> followings;
  final DocumentReference? reference;

  UserModel.fromMap(Map map, this.userKey, {this.reference})
      : profileImg = map[KEY_PROFILEIMG],
        username = map[KEY_USERNAME],
        email = map[KEY_EMAIL],
        likedPosts = map[KEY_LIKEPOSTS],
        followers = map[KEY_FOLLOWERS],
        followings = map[KEY_FOLLOWINGS],
        myPosts = map[KEY_MYPOSTS];

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
      snapshot.data as Map,
      // snapshot
      snapshot.id,
      reference : snapshot.reference
  );

  ///*********************   Debug 성공 코드   *********************///
  UserModel.fromM(DocumentSnapshot map, this.userKey, {this.reference})
      : profileImg = map[KEY_PROFILEIMG],
        username = map[KEY_USERNAME],
        email = map[KEY_EMAIL],
        likedPosts = map[KEY_LIKEPOSTS],
        followers = map[KEY_FOLLOWERS],
        followings = map[KEY_FOLLOWINGS],
        myPosts = map[KEY_MYPOSTS];

  UserModel.fromSs(DocumentSnapshot snapshot)
  : this.fromM(snapshot, snapshot.id, reference: snapshot.reference);
  ///*********************   Debug 성공 코드   *********************///


  static Map<String, dynamic> getMapForCreateUser(String email) {
    Map<String, dynamic> map = Map();
    map[KEY_PROFILEIMG] = "";
    map[KEY_USERNAME] = email.split('@')[0];
    map[KEY_EMAIL] = email;
    map[KEY_LIKEPOSTS] = [];
    map[KEY_FOLLOWERS] = 0;
    map[KEY_FOLLOWINGS] = [];
    map[KEY_MYPOSTS] = [];

    return map;
  }

}
