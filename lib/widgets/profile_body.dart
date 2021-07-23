import 'package:flutter/material.dart';
import 'package:flutter_code_split/constants/common_vars.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                _username(),
                _userBio(),
                _editProfileButton()
              ]),
            )
          ],
        )
    );
  }

  Widget _username() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_padding_m),
      child: Text('user name', style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }

  Widget _userBio() {
    return Text("Developed By Edward.", style: TextStyle(fontWeight: FontWeight.w400),);
  }

  Padding _editProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_padding_m),
      child: SizedBox(
        height: common_padding_l,
        child: OutlineButton(
          onPressed: (){},
          borderSide: BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(common_radius)),
          child: Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold),),),
      ),
    );
  }
}
