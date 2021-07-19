import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_split/constants/common_vars.dart';
import 'package:flutter_code_split/widgets/custom_progress_indicator.dart';

class Post extends StatelessWidget {
  final int index;

  const Post(this.index, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _postHeader(),
        _postImage(),
        _postActions(),
        _postLikes(),
      ],
    );
  }

  Widget _postHeader() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_padding_m),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/id/${index+30}/100/100',
              width: common_profile_img_size_s,
              height: common_profile_img_size_s,),
          ),
        ),
        Expanded(
            child: Text('user$index', style: TextStyle(fontWeight: FontWeight.w500),)),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz_outlined)
        ),
      ],
    );

  }

  CachedNetworkImage _postImage() {
    return CachedNetworkImage(
      imageUrl: "https://picsum.photos/id/$index/200/200",
      imageBuilder: (BuildContext context, ImageProvider imageProvider){
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover)),),
        );},
      placeholder: (BuildContext context, String url) {
        return CustomProgressIndicator(containerSize: size!.width,);
      },
    );
  }

  Row _postActions() {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () {},
          icon: ImageIcon(
              AssetImage('assets/images/like.png'),
              color: Colors.black
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: ImageIcon(
              AssetImage('assets/images/comment.png'),
              color: Colors.black
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: ImageIcon(
              AssetImage('assets/images/direct_message.png'),
              color: Colors.black
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () {},
          icon: ImageIcon(
              AssetImage('assets/images/bookmark.png'),
              color: Colors.black
          ),
        ),
      ],
    );
  }

  Padding _postLikes() {
    return Padding(
      padding: const EdgeInsets.only(left: common_padding_m),
      child: Text('좋아요 $index개', style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }



}