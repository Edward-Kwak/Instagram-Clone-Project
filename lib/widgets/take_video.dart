import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool stopRec = true;


  @override
  Widget build(BuildContext context) {
    return Consumer<CameraState>(
      builder: (context, cameraState, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size!.width,
              height: size!.width,
              color: Colors.black,
              child: (cameraState.isReadyToTakeVideo) ?  _getPreview(cameraState): _progress,
            ),
            Expanded(
                child: IconButton(
                  onPressed: (){
                    setState(() {
                      stopRec = !stopRec;
                    });
                    _attemptTakeVideo(cameraState, context, stopRec);

                  },
                  icon: Icon(
                    Icons.fiber_manual_record_outlined,
                    color: Colors.redAccent,
                  ),
                  iconSize: size!.width/4,
                )
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

  void _attemptTakeVideo(CameraState cameraState, BuildContext context, bool stopFlag) async{
    final String postKey = getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel!);

    print('*****************************video mode :'+postKey);

    if(stopFlag) { /// stop Record
      try {
        // await cameraState.controller.prepareForVideoRecording();

        final XFile takenVideo = await cameraState.controller.stopVideoRecording();

        print('XFile taken video is :');
        print(takenVideo);


        final String path = takenVideo.path;
        print("Taken Video path is : $path");
        await takenVideo.saveTo(path);

        // Directory outPutPath = await

        // Directory appDocDir = await getApplicationDocumentsDirectory();
        // Directory? appDocDir = await getDownloadsDirectory();
        // Directory appDocDir = await getApplicationSupportDirectory();
        // Directory? appDocDir = await getExternalStorageDirectory();


        // Directory savePath = await appDocDir!.create(recursive: true);
        //
        // print('**********************************app Doc Dir is  :' + appDocDir.toString());
        //
        // print('save path : ' + savePath.toString());
        //
        // String realSavePath = savePath.toString().substring(12,savePath.toString().length-1) + '/';
        //
        // print('Real Save Path is : '+realSavePath);

        // await takenVideo.saveTo(realSavePath);

        SimpleSnackBar(context, '영상 저장 완료 !' + path);
        print('******************************************Save Completed !!!');

        // File imageFile = File(path);
        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => SharePostScreen(imageFile, postKey: postKey,)));

        // final XFile takenPic =
        // final String path = takenPic.path;

        // print("Taken Picture path is : $path");

        // File imageFile = File(path);
        // File imageFile = await File(path).create(recursive: true);

        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => SharePostScreen(imageFile, postKey: postKey,)));

      } catch (e) {

      }
    }
    else {
      try {
        cameraState.controller.startVideoRecording();

        SimpleSnackBar(context, '영상 촬영을 시작합니다.');


      }catch(e) {

      }

    }

  }


}
