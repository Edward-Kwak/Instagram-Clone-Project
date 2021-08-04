import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:make_feed_screen/constants/common_size.dart';
import 'package:make_feed_screen/constants/screen_size.dart';
import 'package:make_feed_screen/models/firestore/post_model.dart';
import 'package:make_feed_screen/models/firestore/user_model.dart';
import 'package:make_feed_screen/models/firestore/user_model_state.dart';
import 'package:make_feed_screen/repo/helper/generate_post_key.dart';
import 'package:make_feed_screen/repo/image_network_repository.dart';
import 'package:make_feed_screen/repo/post_network_repository.dart';
import 'package:make_feed_screen/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';

class SharePostScreen extends StatefulWidget {
  final File imageFile;
  final String postKey;

  SharePostScreen(this.imageFile, {Key? key, required this.postKey}) : super(key: key);

  @override
  _SharePostScreenState createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
  TextEditingController _textEditingController = TextEditingController();

  List<String> _tagItems = [
    '강서구',
    '강북구',
    '강남구',
    '강동구',
    '관악구',
    '구로구',
    '광진구',
    '금천구',
    '노원구',
    '도봉구',
    '동작구',
    '동대문구',
    '마포구',
    '서대문구',
    '성북구',
    '성동구',
    '서초구',
    '송파구',
    '양천구',
    '은평구',
    '용산구',
    '영등포구',
    '중구',
    '종로구',
    '중랑구',
  ];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Post"),
          actions: <Widget>[
            FlatButton(
                onPressed: sharePostProcedure,
                child: Text("Share", textScaleFactor: 1.4, style: TextStyle(color: Colors.blue),)),
          ],),
        body: ListView(
          children: [
            _captionWithImage(),
            _divider,
            _sectionButton('Tag People'),
            _divider,
            _sectionButton('Add Location'),
            _tags(),
            SizedBox(height: common_padding_v,),
            _divider,
            SectionSwitch(title: 'Facebook',),
            SectionSwitch(title: 'Twitter',),
            SectionSwitch(title: 'Line',),
            _divider,
          ],
        )
    );
  }

  void sharePostProcedure () async {
    showModalBottomSheet(
        context: context,
        builder: (_) => MyProgressIndicator(),
        enableDrag: false,
        isDismissible: false);

    await imageNetworkRepository.uploadImage(widget.imageFile, postKey: widget.postKey);

    UserModel userModel = Provider.of<UserModelState>(context, listen: false).userModel!;

    await postNetworkRepository.createNewPost(widget.postKey, PostModel.getMapForCreatePost(userModel.userKey, userModel.username, _textEditingController.text));

    String postImgLink = await imageNetworkRepository.getPostImageUrl(widget.postKey);

    await postNetworkRepository.updatePostImageUrl(postImgLink, widget.postKey);

    Navigator.of(context).pop();      //  Dismiss ProgressIndicator
    Navigator.of(context).pop();      //  Dismiss SharePostScreen
  }

  Tags _tags() {
    return Tags(
      horizontalScroll: true,
      itemCount: _tagItems.length,
      itemBuilder: (index) => ItemTags(
        title: _tagItems[index],
        index: index,
        activeColor: Colors.grey,
        textActiveColor: Colors.black87,
        borderRadius: BorderRadius.circular(4),
        elevation: 2,
        color: Colors.lightBlueAccent,
      ),
      heightHorizontalScroll: 30,
    );
  }

  ListTile _sectionButton(String title) {
    return ListTile(
            title: Text(title, style: TextStyle(fontWeight: FontWeight.w400),),
            trailing: Icon(Icons.navigate_next),
            contentPadding: EdgeInsets.symmetric(horizontal: common_padding_h),
            dense: true,
          );
  }

  Divider get _divider => Divider(color: Colors.grey[300], thickness: 1, height: 1,);

  ListTile _captionWithImage() {
    return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: common_padding_h, vertical: common_padding_h),
            leading: Image.file(
              widget.imageFile,
              width: size!.width/6,
              height: size!.width/6,
              fit: BoxFit.cover,),
            title: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: 'Write a caption ...',
                  border: InputBorder.none),
            ),
          );
  }
}

class SectionSwitch extends StatefulWidget {

  final String title;

  const SectionSwitch({
    Key? key, required this.title,
  }) : super(key: key);

  @override
  _SectionSwitchState createState() => _SectionSwitchState();
}

class _SectionSwitchState extends State<SectionSwitch> {

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.w400),),
      trailing: CupertinoSwitch(
          value: checked,
          onChanged: (onValue) {
            setState(() {
              checked = onValue;
            });
          }),
      contentPadding: EdgeInsets.symmetric(horizontal: common_padding_h),
      dense: true,
    );
  }
}
