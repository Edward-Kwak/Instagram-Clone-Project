import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_feed_screen/constants/firestore_keys.dart';

class CommentModel {
  final String userName;
  final String userKey;
  final String comment;
  final DateTime commentTime;
  final String commentKey;
  final DocumentReference? reference;


  ///*********************   Debug 성공 코드   *********************///
  CommentModel.fromM(DocumentSnapshot map, this.commentKey, {this.reference})
      : userName = map[KEY_USERNAME],
        userKey = map[KEY_USERKEY],
        comment = map[KEY_COMMENT],
        commentTime = map[KEY_COMMENTTIME] == null ?
        DateTime.now().toUtc() : (map[KEY_COMMENTTIME] as Timestamp).toDate();


  CommentModel.fromSs(DocumentSnapshot snapshot)
      : this.fromM(snapshot, snapshot.id, reference: snapshot.reference);
  ///*********************   Debug 성공 코드   *********************///


  static Map<String, dynamic> getMapForNewComment(String userKey, String userName, String comment) {
    Map<String, dynamic> map = Map();
    map[KEY_USERNAME] = userName;
    map[KEY_USERKEY] = userKey;
    map[KEY_COMMENT] = comment;
    map[KEY_COMMENTTIME] = DateTime.now().toUtc();

    return map;
  }

}