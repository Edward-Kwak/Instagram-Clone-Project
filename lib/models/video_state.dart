import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class VideoState extends ChangeNotifier {
  CameraController? _cameraController;
  CameraDescription? _cameraDescription;
  bool _readyToTakeVideo = false;


  void dispose() {
    if (_cameraController != null)      _cameraController!.dispose();

    _cameraController = null;
    _cameraDescription = null;
    _readyToTakeVideo = false;

    notifyListeners();
  }

  void getReadyToTakeVideo() async {
    List<CameraDescription> cameras = await availableCameras();

    if (cameras != null && cameras.isNotEmpty) {
      setCameraDescription(cameras[0]);
    }

    bool init = false;
    while(!init) {
      init = await initialize();
    }

    _readyToTakeVideo = true;
    notifyListeners();
  }

  void setCameraDescription(CameraDescription cameraDescription) {
    _cameraDescription = cameraDescription;
    _cameraController = CameraController(_cameraDescription!, ResolutionPreset.medium);
  }

  Future<bool> initialize() async {
    try {
      await _cameraController!.initialize();
      return true;
    } catch(e) {
      return false;
    }
  }

  CameraController? get videoController => _cameraController;
  CameraDescription? get videoDescription => _cameraDescription;
  bool get readyToTakeVideo => _readyToTakeVideo;
}