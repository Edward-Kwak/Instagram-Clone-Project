import 'package:flutter/material.dart';
import 'package:flutter_code_split/constants/common_vars.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double? containerSize;
  final double? progressSize;

  const CustomProgressIndicator({Key? key, this.containerSize, this.progressSize = common_loading_size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize,
      height: containerSize,
      child: Center(
        child: SizedBox(
            width: progressSize,
            height: progressSize,
            child: Image.asset('assets/images/loading_ed4.gif')
        ),),
    );
  }
}
