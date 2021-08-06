import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraState extends ChangeNotifier {
  CameraController? _controller;
  CameraDescription? _cameraDescription;
  bool _readyTakePhoto = false;
  bool _readyTakeVideo = false;

  void dispose() {
    if (_controller != null)      _controller!.dispose();

    _controller = null;
    _cameraDescription = null;
    _readyTakePhoto = false;
    _readyTakeVideo = false;

    notifyListeners();
  }

  void getReadyToTakePhoto() async {
    List<CameraDescription> cameras = await availableCameras();

    if (cameras != null && cameras.isNotEmpty) {
      setCameraDescription(cameras[0]);
    }

    bool init = false;
    while(!init) {
      init = await initialize();
    }

    _readyTakePhoto = true;
    notifyListeners();
  }

  ///******************************** 추가 ********************************///
  void getReadyToTakeVideo(CameraController camera) async {
    bool init = false;

    while(!init) {
      init = await initializeVideo();
    }

    _readyTakeVideo = true;
    notifyListeners();
  }
  ///********************************************************************///


  void setCameraDescription(CameraDescription cameraDescription) {
    _cameraDescription = cameraDescription;
    _controller = CameraController(_cameraDescription!, ResolutionPreset.medium);
  }

  Future<bool> initialize() async {
    try {
      await _controller!.initialize();
      return true;
    } catch(e) {
      return false;
    }
  }

  ///******************************** 추가 ********************************///
  Future<bool> initializeVideo() async {
    try {
      await _controller!.prepareForVideoRecording();
      return true;
    }
    catch(e) {
      return false;
    }
  }
  ///********************************************************************///


  CameraController get controller => _controller!;
  CameraDescription get description => _cameraDescription!;
  bool get isReadyToTakePhoto => _readyTakePhoto;
  bool get isReadyToTakeVideo => _readyTakeVideo;
}