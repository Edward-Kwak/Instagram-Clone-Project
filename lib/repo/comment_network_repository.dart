import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_feed_screen/constants/firestore_keys.dart';
import 'package:make_feed_screen/models/firestore/comment_model.dart';
import 'package:make_feed_screen/repo/helper/transformers.dart';

class CommentNetworkRepository with Transformers {

  Future<void> createNewComment (String postKey, Map<String, dynamic> commentData) async {
    final DocumentReference postRef = FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();
    final DocumentReference commentRef = postRef.collection(COLLECTION_COMMENTS).doc();

    return FirebaseFirestore.instance.runTransaction((tx) async {
      if (postSnapshot.exists) {
        await tx.set(commentRef, commentData);
        int numOfComments = postSnapshot[KEY_NUMOFCOMMENTS] + 1;
        await tx.update(
            postRef,
            {
              KEY_NUMOFCOMMENTS: numOfComments,
              KEY_LASTCOMMENT: commentData[KEY_COMMENT],
              KEY_LASTCOMMENTOR: commentData[KEY_USERNAME],
              KEY_LASTCOMMENTTIME: commentData[KEY_COMMENTTIME],
            });
      }
    });
  }

  Stream<List<CommentModel>> fetchAllComments (String postKey) {

    return FirebaseFirestore.instance
        .collection(COLLECTION_POSTS)
        .doc(postKey)
        .collection(COLLECTION_COMMENTS)
        .orderBy(KEY_COMMENTTIME, descending: true)
        .snapshots()
        .transform(toComments);
  }

}

CommentNetworkRepository commentNetworkRepository = CommentNetworkRepository();