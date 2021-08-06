
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_feed_screen/constants/firestore_keys.dart';
import 'package:make_feed_screen/models/firestore/post_model.dart';
import 'package:make_feed_screen/repo/helper/transformers.dart';
import 'package:rxdart/rxdart.dart';

class PostNetworkRepository {

  Future<void> createNewPost(String postKey, Map<String, dynamic> postData) async {

    final DocumentReference postRef = FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);

    final DocumentSnapshot postSnapshot = await postRef.get();

    final DocumentReference userRef = FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(postData[KEY_USERKEY]);

    return FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (!postSnapshot.exists) {
        await tx.set(postRef, postData);
        await tx.update(userRef, {KEY_MYPOSTS: FieldValue.arrayUnion([postKey])});
      }
    });
  }

  Future<void> updatePostImageUrl(String postImg, String postKey) async {

    final DocumentReference postRef = FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      await postRef.update({KEY_POSTIMG: postImg});
    }
  }

  Stream<List<PostModel>> getPostsFromSpecificUser (String userKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_POSTS)
        .where(KEY_USERKEY, isEqualTo: userKey)
        .snapshots()
        .transform(Transformers().toPosts.cast());
  }

  Stream<List<PostModel>> fetchPostsFromAllFollowers(List<dynamic> followings) {
    final CollectionReference collectionReference = FirebaseFirestore.instance.collection(COLLECTION_POSTS);

    List<Stream<List<PostModel>>> streams = [];

    for (final followingUser in followings) {
      streams.add(collectionReference.where(KEY_USERKEY, isEqualTo: followingUser).snapshots().transform(Transformers().toPosts));
    }

    return CombineLatestStream.list<List<PostModel>>(streams).transform(Transformers().combineListOfPosts).transform(Transformers().latestToTop);
  }

  Future<void> toggleLike(String postKey, String userKey) async {
    final DocumentReference postRef = FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      if(postSnapshot[KEY_NUMOFLIKES].contains(userKey)) {
        postRef.update({KEY_NUMOFLIKES: FieldValue.arrayRemove([userKey])});
      }
      else {
        postRef.update({KEY_NUMOFLIKES: FieldValue.arrayUnion([userKey])});
      }
    }
  }

}

PostNetworkRepository postNetworkRepository = PostNetworkRepository();