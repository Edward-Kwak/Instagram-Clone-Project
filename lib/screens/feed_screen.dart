import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/common_size.dart';
import 'package:make_feed_screen/models/firestore/post_model.dart';
import 'package:make_feed_screen/repo/post_network_repository.dart';
import 'package:make_feed_screen/repo/user_network_repository.dart';
import 'package:make_feed_screen/widgets/my_progress_indicator.dart';
import 'package:make_feed_screen/widgets/post.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  final List<dynamic> followings;

  const FeedScreen(this.followings, {Key? key}) : super(key: key);

  //  쿠퍼티노 디자인 AppBar
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostModel>>.value(
      initialData: [],
      value: postNetworkRepository.fetchPostsFromAllFollowers(followings),
      // catchError:(context, error) => null as List<PostModel>,
      child: Consumer<List<PostModel>>(
        builder: (context, posts ,child) {
          if (posts == null || posts.isEmpty) {
            return MyProgressIndicator();
          }
          else {
            return Scaffold(
                appBar: CupertinoNavigationBar(
                  leading: IconButton(
                    onPressed: () {},
                    icon: ImageIcon(AssetImage('assets/images/insta_text_logo.png')),
                    iconSize: common_appbar_height,
                  ),

                  // middle: Text('Edward instagram', style: TextStyle(
                  //     fontFamily: 'VeganStyle', color: Colors.black)),

                  //trailing: IconButton(onPressed: null, icon: Icon(Icons.share_outlined)),      //  이 방법은 앱 바 우측 끝에 한개의 이미지만 넣을 때 가능.

                  trailing: Row( //  앱 바 우측 끝에 여러 이미지를 넣을 땐, Row를 사용할 것.
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                            // userNetworkRepository.sendData();

                            // userNetworkRepository.getAllUsersWithoutMe().listen((users) {
                            //   print(users);
                            // });
                        },
                        icon: ImageIcon(AssetImage('assets/images/like.png'), color: Colors.black,),
                        iconSize: 28,
                      ),
                      IconButton(
                        onPressed: () {
                            // userNetworkRepository.getData();
                        },
                        icon: ImageIcon(AssetImage(
                              'assets/images/direct_message.png'), color: Colors.black,),
                        iconSize: 28,
                      )
                    ],

                  ),
                ),
                body: ListView.builder(
                    itemBuilder: (context, index) => feedListBuilder(context, posts[index]),
                    itemCount: posts.length)
            );
          }

        },
      ),
    );
  }

  Widget feedListBuilder(BuildContext context, PostModel postModel) {
    return Post(postModel);
  }
}
