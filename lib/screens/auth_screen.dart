import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/common_size.dart';
import 'package:make_feed_screen/widgets/fade_stack.dart';
import 'package:make_feed_screen/widgets/sign_in_form.dart';
import 'package:make_feed_screen/widgets/sign_up_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  List<Widget> forms = [SignUpForm(), SignInForm()];

  // Widget signUpForm = SignUpForm();
  // Widget signInForm = SignInForm();
  // Widget? currentWidget;

  int selectedForm = signUpScreen;

  // @override
  // void initState() {
  //   // if (currentWidget == null) currentWidget = signUpForm;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            FadeStack(selectedForm, listForms: forms),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 40,
              child: Container(
                color: Colors.white,
                child: FlatButton(
                  onPressed: (){
                    setState(() {
                      if(selectedForm == signUpScreen) selectedForm = signInScreen;
                      else selectedForm = signUpScreen;
                    });
                  },
                  shape: Border(top: BorderSide(color: Colors.grey)),
                  child: RichText(
                    text: TextSpan(
                        text: (selectedForm == signUpScreen) ? 'Already have an account? ' : "Don't have an account? ",
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: (selectedForm == signUpScreen) ? 'Sign In' : 'Sign Up',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),),
                        ]),)
              ),
          ),
            ),]
        ),
      ),
    );
  }
}
