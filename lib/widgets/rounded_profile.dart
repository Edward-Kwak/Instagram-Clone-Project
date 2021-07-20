import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_split/constants/common_vars.dart';

class RoundedProfile extends StatelessWidget {
  final double size;

  const RoundedProfile({
    Key? key,
    this.size = common_profile_img_size_s,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: 'https://picsum.photos/100',
        width: size,
        height: size,),
    );
  }
}