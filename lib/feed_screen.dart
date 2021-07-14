import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_code_split/widgets/post.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: IconButton(
          onPressed: (){},
          iconSize: 120,
          icon: ImageIcon(AssetImage('assets/images/insta_text_logo.png',),),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage('assets/images/like.png'))),
            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage('assets/images/direct_message.png')))],),
      ),
      body: ListView.builder(itemBuilder: feedListBuilder, itemCount: 30,),
    );
  }


  Widget feedListBuilder(BuildContext context, int index) {
    return Post(index);
  }

}

