import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/common_size.dart';
import 'package:make_feed_screen/widgets/rounded_profile.dart';

class Comment extends StatelessWidget {
  final bool showProfileImg;
  final String userName;
  final String text;
  final DateTime? dateTime;

  Comment({
    Key? key,
    this.showProfileImg = true, required this.userName, required this.text, this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(showProfileImg)  RoundedProfile(size: 24),
        if(showProfileImg)  SizedBox(width: common_padding_h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: userName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      TextSpan(text: ' '),
                      TextSpan(text: text, style: TextStyle(color: Colors.black)),
                    ]
                )
            ),
            if(dateTime != null) Text(dateTime!.toIso8601String(), style: TextStyle(color: Colors.grey[500], fontSize: 11.0)),
          ],
        ),
      ],
    );
  }
}
