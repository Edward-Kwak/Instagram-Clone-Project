import 'package:flutter/material.dart';
import 'package:flutter_code_split/constants/common_vars.dart';
import 'package:flutter_code_split/widgets/rounded_profile.dart';

class Comment extends StatelessWidget {

  final bool showProfileImg;
  final String userName;
  final String text;
  final DateTime? timeStamp;
  // final int index;


  const Comment({
    Key? key,
    this.showProfileImg = true, required this.userName, required this.text, this.timeStamp,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(showProfileImg) RoundedProfile(size: common_padding_l),
        if(showProfileImg) SizedBox(width: common_padding_m,),
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
            if(timeStamp != null) Text(timeStamp!.toIso8601String(), style: TextStyle(color: Colors.grey[400], fontSize: common_padding_m),),
          ],
        ),
      ],
    );
  }
}
