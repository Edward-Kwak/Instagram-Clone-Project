import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:make_feed_screen/models/firestore/user_model_state.dart';
import 'package:make_feed_screen/models/gallery_state.dart';
import 'package:make_feed_screen/repo/helper/generate_post_key.dart';
import 'package:make_feed_screen/screens/share_post_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MyGallery extends StatefulWidget {
  const MyGallery({Key? key}) : super(key: key);

  @override
  _MyGalleryState createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryState>(
      builder: (context, galleryState, child) {
        return GridView.count(
          crossAxisCount: 3,
          children: getImages(context, galleryState),
          // children: List.generate(
          //   30,
          //       (index) => Image.network('https://picsum.photos/id/${index+90}/100/100'),
          // ),
        );
      },
    );
  }

  List<Widget> getImages(BuildContext context, GalleryState galleryState) {
    return galleryState.images.map( (localImage) {
      return InkWell(
          onTap: () async {
            Uint8List imgToBytes = await localImage.getScaledImageBytes(galleryState.localImageProvider, 0.3);

            final String postKey = getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel!);

            try {
              final path = join( (await getTemporaryDirectory()).path, "$postKey.png" );

              File imageFile = File(path)..writeAsBytesSync(imgToBytes);

              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SharePostScreen(imageFile, postKey: postKey,)));

            } catch(e) {}
          },
          child: Image(
            image: DeviceImage(localImage, scale: 0.1),
            fit: BoxFit.cover,)
      );
    }).toList();
  }

  /************  SharePostScreen 변경 전 코드 ************/
  // List<Widget> getImages(BuildContext context, GalleryState galleryState) {
  //   return galleryState.images.map( (localImage) {
  //     return InkWell(
  //         onTap: () async {
  //           Uint8List imgToBytes = await localImage.getScaledImageBytes(galleryState.localImageProvider, 0.3);
  //
  //           final String timeInMillis = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //           try {
  //             final path = join( (await getTemporaryDirectory()).path, "$timeInMillis.png" );
  //
  //             File imageFile = File(path)..writeAsBytesSync(imgToBytes);
  //
  //             Navigator.of(context).push(MaterialPageRoute(builder: (_) => SharePostScreen(imageFile)));
  //
  //           } catch(e) {}
  //         },
  //         child: Image(
  //           image: DeviceImage(localImage, scale: 0.1),
  //           fit: BoxFit.cover,)
  //     );
  //   }).toList();
  // }
  /************  SharePostScreen 변경 전 코드 ************/

}
