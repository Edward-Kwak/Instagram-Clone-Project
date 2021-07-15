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
}