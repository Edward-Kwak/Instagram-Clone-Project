import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/common_size.dart';
import 'package:make_feed_screen/constants/screen_size.dart';
import 'package:make_feed_screen/models/camera_state.dart';
import 'package:make_feed_screen/models/firestore/user_model_state.dart';
import 'package:make_feed_screen/repo/helper/generate_post_key.dart';
import 'package:make_feed_screen/screens/share_post_screen.dart';
import 'package:make_feed_screen/widgets/my_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TakePhoto extends StatefulWidget {
  const TakePhoto({
    Key? key,
  }) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {

  // late CameraController _cameraController;

  // 캠 컨트롤러를 null 표시자로 해도 문제 없는듯함. 문제 생기면, ?표시자 말고, late로 하자.

  Widget _progress = MyProgressIndicator();

  @override
  Widget build(BuildContext context) {
    // if (!snapshot.hasData) return _progress;          // 이렇게 해줘야 에러가 안나는 것 같은데? Container의 child에 삼항 연산자로 적용하면 에러나는듯.
    return Consumer<CameraState>(
      builder: (context, cameraState, child) {

        // if (!cameraState.isReadyToTakePhoto) return _progress;

        return Column(
          children: <Widget>[
            Container(
              width: size!.width,
              height: size!.width,
              color: Colors.black,
              child: (cameraState.isReadyToTakePhoto) ? _getPreview(cameraState) : _progress,
            ),
            Expanded(
              child: OutlineButton(
                onPressed: () {
                  if (cameraState.isReadyToTakePhoto) {
                    _attemptTakePhoto(cameraState, context);
                  }
                },
                shape: CircleBorder(),
                borderSide: BorderSide(color: Colors.black12, width: 20),
              ),
            ),
          ],
        );
      }, // builder Parameter
    );
  }

  Widget _getPreview(CameraState cameraState) {

    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Container(
              width: size!.width,
              height: size!.width * cameraState.controller.value.aspectRatio,
              child: CameraPreview(cameraState.controller)),
        ),
      ),
    );

  }


  void _attemptTakePhoto(CameraState cameraState, BuildContext context) async{
    final String postKey = getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel!);

    try {

      final XFile takenPic = await cameraState.controller.takePicture();
      final String path = takenPic.path;

      print("Taken Picture path is : $path");


      File imageFile = File(path);
      // File imageFile = await File(path).create(recursive: true);

      Navigator.of(context).push(MaterialPageRoute(builder: (_) => SharePostScreen(imageFile, postKey: postKey,)));

    } catch(e) {

    }
  }


  /************  SharePostScreen 변경 전 코드 ************/
  // void _attemptTakePhoto(CameraState cameraState, BuildContext context) async{
  //   final String timeInMillis = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //   try {
  //     // final path = join( (await getTemporaryDirectory()).path, "$timeInMillis.png" );
  //     // await cameraState.controller.takePicture(path)
  //
  //     final XFile takenPic = await cameraState.controller.takePicture();
  //     final String path = takenPic.path;
  //
  //     print("Taken Picture path is : $path");
  //
  //     File imageFile = File(path);
  //
  //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => SharePostScreen(imageFile)));
  //
  //   } catch(e) {
  //
  //   }
  // }
  /************  SharePostScreen 변경 전 코드 ************/



  /************  직접 디버깅해서 성공한 코드 _cameraController를 late로 선언했을 때. ************/
  // Widget _getPreview(AsyncSnapshot<List<CameraDescription>> cameras) {
  //   _cameraController = CameraController(cameras.data![0], ResolutionPreset.medium);
  //
  //   return FutureBuilder(
  //     future: _cameraController.initialize(),
  //     builder: (context, snapshot) {
  //       if(snapshot.connectionState == ConnectionState.done && _cameraController.value.isInitialized)
  //         return CameraPreview(_cameraController);
  //       else
  //         return _progress;
  //     },
  //   );
  // } // End of _getPreview
  /************  직접 디버깅해서 성공한 코드 _cameraController를 late로 선언했을 때. ************/

}