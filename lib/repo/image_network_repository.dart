import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:make_feed_screen/repo/helper/image_helper.dart';
import 'package:path_provider/path_provider.dart';

class ImageNetworkRepository {

  // Future<void> uploadImageNCreateNewPost(File originImage, {required String postKey}) async {
  Future<TaskSnapshot> uploadImage(File originImage, {required String postKey}) async {

    try {
      final File resized = await compute(getResizedImage, originImage);

      final Reference reference = FirebaseStorage.instance.ref().child(_getImagePathByPostKey(postKey));

      final UploadTask uploadTask = reference.putFile(resized);

      return uploadTask.then((storageTaskSnapshot) => storageTaskSnapshot);

      // final StorageDirectory storageDirectory = FirebaseStorage().ref().child(_getImagePathByPostKey(postKey));
      // originImage.length().then((value) => print('original image size : $value'));
      // resized.length().then((value) => print('resized image size : $value'));
      // await Future.delayed(Duration(seconds: 3));
    }
    catch (e) {
      print('in uploadImageNCreateNewPost Method, Error !');
      print(e);
      throw Error();
    }
  }

  String _getImagePathByPostKey(String postKey) => 'post/$postKey/post.jpg';

  Future<dynamic> getPostImageUrl(String postKey) {
    return FirebaseStorage.instance.ref().child(_getImagePathByPostKey(postKey)).getDownloadURL();
  }

}

ImageNetworkRepository imageNetworkRepository = ImageNetworkRepository();