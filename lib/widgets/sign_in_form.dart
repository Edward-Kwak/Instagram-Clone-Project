import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/common_size.dart';
import 'package:make_feed_screen/home_page.dart';
import 'package:make_feed_screen/models/firebase_auth_state.dart';
import 'package:make_feed_screen/widgets/auth_input_decor.dart';
import 'package:make_feed_screen/widgets/or_divider.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(common_padding_h),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: common_padding_v,),
              Image.asset('assets/images/insta_text_logo.png'),
              TextFormField(
                controller: _emailController,
                cursorColor: Colors.black54,
                decoration: textInputDecor('Email'),
                validator: (text) {
                  if (text!.isNotEmpty && text.contains("@")) {
                    return null;
                  }
                  else {
                    return '정확한 이메일 주소를 입력하세요.';
                  }
                },
              ),
              SizedBox(height: common_padding_v,),
              TextFormField(
                  controller: _pwController,
                  cursorColor: Colors.black54,
                  obscureText: true,
                  decoration: textInputDecor('Password'),
                  validator: (text) {
                    if (text!.isNotEmpty && text.length >= 8) {
                      return null;
                    }
                    else {
                      return '제대로 된 비밀번호를 입력해 주세요.';
                    }
                  }
              ),
              SizedBox(height: common_padding_v,),
              FlatButton(
                  onPressed: () {},
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgotten Password?',
                        style: TextStyle(color: Colors.blue),)),
              ),
              SizedBox(height: common_padding_v,),
              _submitButton(context),
              SizedBox(height: common_padding_v,),
              OrDivider(),
              FlatButton.icon(
                onPressed: () {
                  Provider.of<FirebaseAuthState>(context, listen: false).logInWithFacebook(context);
                },
                icon: ImageIcon(AssetImage('assets/images/facebook.png')),
                textColor: Colors.blue,
                label: Text('Login with Facebook'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FlatButton _submitButton(BuildContext context) {
    return FlatButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {

          print('로그인 성공 !!');

          Provider.of<FirebaseAuthState>(context, listen: false).changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
          Provider.of<FirebaseAuthState>(context, listen: false).logIn(context, email: _emailController.text, password: _pwController.text);
          Provider.of<FirebaseAuthState>(context, listen: false).changeFirebaseAuthStatus();
        }
        else  print('로그인 실패.');
      },
      child: Text(
        'Log In', style: TextStyle(color: Colors.white),),
      color: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(common_radius)),
    );
  }
}
