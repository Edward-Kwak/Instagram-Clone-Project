import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_feed_screen/models/camera_state.dart';
import 'package:make_feed_screen/models/gallery_state.dart';
import 'package:make_feed_screen/screens/profile_screen.dart';
import 'package:make_feed_screen/widgets/my_gallery.dart';
import 'package:make_feed_screen/widgets/take_photo.dart';
import 'package:make_feed_screen/widgets/take_video.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {

  CameraState _cameraState = CameraState();
  GalleryState _galleryState = GalleryState();
  // const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() {
    _cameraState.getReadyToTakePhoto();
    _galleryState.initProvider();
    /// get Ready To Take Video
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {

  int _currentIndex = 1;
  PageController _pageController = PageController(initialPage: 1);
  String appBarTitle = "Photo";

  @override
  void dispose() {
    _pageController.dispose();
    widget._cameraState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CameraState>.value(value: widget._cameraState),
        ChangeNotifierProvider<GalleryState>.value(value: widget._galleryState),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          centerTitle: true,
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            MyGallery(),
            TakePhoto(),
            TakeVideo(),
            // Container(
            //   color: Colors.greenAccent,
            // ),
          ],
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              switch (_currentIndex) {
                case 0:
                  appBarTitle = "Gallery";
                  break;
                case 1:
                  appBarTitle = "Photo";
                  break;
                case 2:
                  appBarTitle = "Video";
                  widget._cameraState.getReadyToTakeVideo(widget._cameraState.controller);
                  break;
              }

            });
          },
        ),

        bottomNavigationBar: BottomNavigationBar(
          iconSize: 0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_checked),
              title: Text('GALLERY')
            ),BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_checked),
              title: Text('PHOTO')
            ),BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_checked),
              title: Text('VIDEO')
            ),
          ],

          currentIndex: _currentIndex,
          onTap: _onItemTabbed,
        ),

      ),
    );
  }

  void _onItemTabbed(index) {
      print("in camera screen, $index");
      setState(() {
        _currentIndex = index;
        _pageController.animateToPage(_currentIndex, duration: duration, curve: Curves.fastOutSlowIn);
      });

  }
}

