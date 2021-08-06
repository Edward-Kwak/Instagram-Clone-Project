import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/common_size.dart';

class RoundedProfile extends StatelessWidget {
  final double size;


  RoundedProfile({
    Key? key, this.size = common_mini_profile_size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(child: CachedNetworkImage(
      imageUrl: 'https://picsum.photos/100',
      width: size,
      height: size,));
  }
}
