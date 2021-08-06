import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:make_feed_screen/constants/firestore_keys.dart';
import 'package:make_feed_screen/models/firestore/comment_model.dart';
import 'package:make_feed_screen/models/firestore/post_model.dart';
import 'package:make_feed_screen/models/firestore/user_model.dart';

import 'package:make_feed_screen/widgets/post.dart';

class Transformers {

  final toUser = StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(
    handleData: (snapshot, sink) async {
      print('******************this is toUser transformer, Using on getUserModelStream');
      print(snapshot);
      print(snapshot[KEY_USERNAME]);
      sink.add(UserModel.fromSs(snapshot));
    }
  );



  final toUsersExceptMe = StreamTransformer<QuerySnapshot, List<UserModel>>.fromHandlers(
      handleData: (snapshot, sink) async {
        print('******************this is transformer, get All Users.');
        print(snapshot);

        List<UserModel> users = [];

        User _user = await FirebaseAuth.instance.currentUser!;

        snapshot.docs.forEach((documentSnapshot) {
          if (_user.uid != documentSnapshot.id)
            users.add(UserModel.fromSs(documentSnapshot));
        });

        sink.add(users);
      }
  );


  // final toPosts = StreamTransformer<QuerySnapshot, List<PostModel>>.fromHandlers(
  //     handleData: (snapshot, sink) async {
  //       print('***************************this is transformer, get Posts form Specific Users.');
  //       print(snapshot);
  //
  //       List<PostModel> posts = [];
  //
  //       snapshot.docs.forEach((documentSnapshot) {
  //         posts.add(PostModel.fromSss(documentSnapshot));
  //       });
  //
  //       sink.add(posts);
  //     }
  // );


  ///*********************   Debug 성공 코드   *********************///
  final toPosts = StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<PostModel>>.fromHandlers(
      handleData: (snapshot, sink) async {
        print('*************************** toPosts transformer, get Posts form Specific Users.');
        print(snapshot);

        List<PostModel> posts = [];

        snapshot.docs.forEach((documentSnapshot) {
            posts.add(PostModel.fromSs(documentSnapshot));
        });

        sink.add(posts);
      }
  );
  ///*********************   Debug 성공 코드   *********************///




  final combineListOfPosts = StreamTransformer<List<List<PostModel>>, List<PostModel>>.fromHandlers(
      handleData: (listOfPosts, sink) async {
        print('*************************** combineListOfPosts transformer, List<List<PostModel>> to List<PostModel>.');
        print(listOfPosts);

        List<PostModel> posts = [];

        for (final postList in listOfPosts) {
          posts.addAll(postList);
        }

        print('after sort, posts are..');
        print(posts);

        sink.add(posts);
      }
  );

  final latestToTop = StreamTransformer<List<PostModel>, List<PostModel>>.fromHandlers(
      handleData: (posts, sink) async {
        print('*************************** latestToTop transformer, sorting all posts.');

        print('before sort, posts are..');
        print(posts);

        posts.sort((a,b) => b.postTime.compareTo(a.postTime));

        print('after sort, posts are..');
        print(posts);

        sink.add(posts);
      }
  );

  final toComments = StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<CommentModel>>.fromHandlers(
      handleData: (snapshot, sink) async {
        print('*************************** toComments transformer, fetch All Comments for a post.');
        print(snapshot);

        List<CommentModel> comments = [];

        snapshot.docs.forEach((documentSnapshot) {
          comments.add(CommentModel.fromSs(documentSnapshot));
        });

        sink.add(comments);
      }
  );



}