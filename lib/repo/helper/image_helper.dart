import 'dart:io';
import 'package:image/image.dart';

File getResizedImage(File originImg) {
  Image? image = decodeImage(originImg.readAsBytesSync());
  Image resizedImage = copyResizeCropSquare(image!, 300);

  File resizedFile = File(originImg.path.substring(0, originImg.path.length - 3) + 'jpg');
  
  resizedFile.writeAsBytesSync(encodeJpg(resizedImage, quality: 60));

  return resizedFile;
}