import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/common_size.dart';
import 'package:make_feed_screen/constants/screen_size.dart';
import 'package:make_feed_screen/models/firestore/post_model.dart';
import 'package:make_feed_screen/models/firestore/user_model_state.dart';
import 'package:make_feed_screen/repo/image_network_repository.dart';
import 'package:make_feed_screen/repo/post_network_repository.dart';
import 'package:make_feed_screen/screens/comments_screen.dart';
import 'package:make_feed_screen/widgets/comment.dart';
import 'package:make_feed_screen/widgets/my_progress_indicator.dart';
import 'package:make_feed_screen/widgets/rounded_profile.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class Post extends StatelessWidget {
  final PostModel postModel;


  Post(this.postModel, {
    Key? key,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _postHeader(),
        _postImage(),
        _postActions(context),
        _postLikes(),
        _postCaptions(),
        _moreComments(context),
        _lastComment(),
      ],
    );
  }

  Widget _lastComment() {
    return Padding(
      padding: const EdgeInsets.only(left: common_padding_h, right: common_padding_h, top: common_padding_v_s),
      child: Comment(
        userName: postModel.lastCommentor,
        text: postModel.lastComment,
        showProfileImg: false,
      ),
    );
  }

  Widget _postCaptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_padding_h,),
      child: Comment(
        userName: postModel.userName,
        text: postModel.caption,
        showProfileImg: false,
      ),
    );
  }

  Padding _postLikes() {
    return Padding(
      padding: const EdgeInsets.only(left: common_padding_h, bottom: common_padding_v_xs),
      child: Text('좋아요 ${postModel.numOfLikes == null ? 0 : postModel.numOfLikes.length}개', style: TextStyle(fontWeight: FontWeight.bold,fontSize: common_font_size_s+1),),
    );
  }

  Row _postActions(BuildContext context) {
    return Row(
        children: <Widget>[
          Consumer<UserModelState>(
            builder: (context, userModelState, child) {
              return IconButton(
                onPressed: () {
                  postNetworkRepository.toggleLike(postModel.postKey, userModelState.userModel!.userKey);
                },
                icon: ImageIcon(
                    AssetImage(postModel.numOfLikes.contains(userModelState.userModel!.userKey) ?
                    'assets/images/heart_selected.png' : 'assets/images/like.png'),
                    color: Colors.redAccent,
                ),
              );
            },
          ),
          IconButton(
              onPressed: () {
                _goToComment(context);
              },
              icon: ImageIcon(AssetImage('assets/images/comment.png'),color: Colors.black),
          ),
          IconButton(
              onPressed: null,
              icon: ImageIcon(AssetImage('assets/images/direct_message.png'),color: Colors.black),
          ),
          Spacer(),
          IconButton(
              onPressed: null,
              icon: ImageIcon(AssetImage('assets/images/bookmark.png'),color: Colors.black),
          )
        ],
      );
  }

  Widget _postHeader() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_padding_h),
          child: RoundedProfile(),
        ),
        Expanded(child: Text(postModel.userName)),
        IconButton(onPressed: null, icon: Icon(Icons.more_horiz, color: Colors.black))
      ],
    );
  }


  Widget _postImage() {
    Widget progress = MyProgressIndicator(containerSize: size!.width, progressSize: size!.width/2,);

    return CachedNetworkImage(
      imageUrl: postModel.postImg,
      placeholder: (BuildContext context, String url) {
        return progress;
      },
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover)
            ),
          ),
        );
      },
    );
  }

  Widget _moreComments(BuildContext context) {
    return Visibility(
      visible: postModel.numOfComments != null && postModel.numOfComments >= 2,
      child: GestureDetector(
        onTap: () {
          _goToComment(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: common_padding_h, right: common_padding_h, top: common_padding_v_s),
          child: Text('댓글 ${postModel.numOfComments-1}개 모두 보기', style: TextStyle(color: Colors.grey,fontSize: common_font_size_s),),
        ),
      ),
    );
  }

  _goToComment (BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentsScreen(postModel.postKey),));
  }

}
