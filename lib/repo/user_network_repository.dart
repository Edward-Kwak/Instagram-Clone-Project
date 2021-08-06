import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:make_feed_screen/constants/firestore_keys.dart';
import 'package:make_feed_screen/models/firestore/user_model.dart';
import 'package:make_feed_screen/repo/helper/transformers.dart';
import 'package:make_feed_screen/utils/simple_snackbar.dart';

class UserNetworkRepository with Transformers {

  Future<void> attemptCreateUser(BuildContext context, {required String userKey, required String email}) async {
    final DocumentReference userRef = FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(userKey);
    
    DocumentSnapshot snapshot = await userRef.get();    //  try.

    if (!snapshot.exists) {
      return await userRef.set(UserModel.getMapForCreateUser(email));
    } else {
      print('******************attemptCreateUser 메소드의 else 문.');
      SimpleSnackBar(context, 'Error While Registering. Try Again Later.\n-Edward');
      return;
    }
  }

  Stream<UserModel> getUserModelStream (String userKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_USERS).doc(userKey)
        .snapshots().transform(toUser.cast());
  }

  Stream<List<UserModel>> getAllUsersWithoutMe() {
    return FirebaseFirestore.instance.collection(COLLECTION_USERS).snapshots().transform(toUsersExceptMe.cast());
  }

  Future<void> followUser(String myUserKey, String otherUserKey) async {
    final DocumentReference myUserRef = FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(myUserKey);
    final DocumentReference otherUserRef = FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(otherUserKey);

    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    FirebaseFirestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists) {
        await tx.update(myUserRef, {KEY_FOLLOWINGS: FieldValue.arrayUnion([otherUserKey])});

        int currentFollowers = otherSnapshot[KEY_FOLLOWERS];
        print('******************follow User method, before follow, cur following users are : $currentFollowers');

        await tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollowers+1});
      }
    });
  }

  Future<void> unfollowUser(String myUserKey, String otherUserKey) async {
    final DocumentReference myUserRef = FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(myUserKey);
    final DocumentReference otherUserRef = FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(otherUserKey);

    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    FirebaseFirestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists) {
        await tx.update(myUserRef, {KEY_FOLLOWINGS: FieldValue.arrayRemove([otherUserKey])});

        int currentFollowers = otherSnapshot[KEY_FOLLOWERS];
        print('******************unfollow User method, before unfollow, cur following users are : $currentFollowers');

        await tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollowers-1});
      }
    });
  }

}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();
