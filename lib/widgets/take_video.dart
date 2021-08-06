import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:make_feed_screen/constants/screen_size.dart';
import 'package:make_feed_screen/models/camera_state.dart';
import 'package:make_feed_screen/models/firestore/user_model_state.dart';
import 'package:make_feed_screen/repo/helper/generate_post_key.dart';
import 'package:make_feed_screen/screens/share_post_screen.dart';
import 'package:make_feed_screen/utils/simple_snackbar.dart';
import 'package:make_feed_screen/widgets/my_progress_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TakeVideo extends StatefulWidget {
  const TakeVideo({Key? key}) : super(key: key);

  @override
  _TakeVideoState createState() => _TakeVideoState();
}

class _TakeVideoState extends State<TakeVideo> {

  Widget _progress = MyProgressIndicator();
  bool isRecording = false;


  @override
  Widget build(BuildContext context) {
    return Consumer<CameraState>(
      builder: (context, cameraState, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: Container(
                width: size!.width,
                height: size!.width,
                color: Colors.black,
                child: (cameraState.isReadyToTakeVideo) ?  _getPreview(cameraState): _progress,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                onPressed: (){
                  setState(() {
                    isRecording = !isRecording;
                  });
                  _attemptTakeVideo(context, cameraState);
                },
                icon: isRecording ?
                Icon(Icons.fiber_manual_record_outlined, color: Colors.redAccent,)
                    : Icon(Icons.stop_circle_outlined, color:Colors.redAccent),
                iconSize: size!.width/4,
              ),
            ),
          ],
        );
      },
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

  void _attemptTakeVideo(BuildContext context, CameraState cameraState) async{
    final String postKey = getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel!);

    print('***************************** Video Screen, PostKey is :'+postKey);

    if (isRecording) {
      cameraState.controller.startVideoRecording();
      SimpleSnackBar(context, '영상 촬영을 시작합니다.');
      print('************************************************* before recording,');
      await Future.delayed(Duration(seconds: 15));
      print('************************************************* after recording,');

      final XFile result = await cameraState.controller.stopVideoRecording();

      SimpleSnackBar(context, '영상 촬영을 중단합니다.');

      print('XFile taken video is :');
      print(result);

      final String resultPath = result.path;
      print("Taken Video path is : $resultPath");
      // await vid.saveTo(vid_path);

      final savedPath = await ImageGallerySaver.saveFile(resultPath);
      print('************************************************* saved Path is : $savedPath');
      SimpleSnackBar(context, '영상 저장 완료 !!\n$savedPath');
    }
    else {

    }


  }


}
