import 'package:flutter/material.dart';
import 'package:make_feed_screen/screens/profile_screen.dart';

class FadeStack extends StatefulWidget {
  final int selectedForm;
  final List<Widget> listForms;

  const FadeStack(this.selectedForm, {Key? key, required this.listForms,}) : super(key: key);

  @override
  _FadeStackState createState() => _FadeStackState();
}

class _FadeStackState extends State<FadeStack> with SingleTickerProviderStateMixin {

  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: icon_duration);
    _animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FadeStack oldWidget) {
    if(widget.selectedForm != oldWidget.selectedForm) {
      _animationController!.forward(from: 0.0);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: IndexedStack(index: widget.selectedForm, children: widget.listForms,),
      opacity: _animationController!,);
  }
}
