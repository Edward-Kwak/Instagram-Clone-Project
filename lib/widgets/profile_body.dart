import 'package:flutter/material.dart';
import 'package:flutter_code_split/constants/common_vars.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool selectedLeft = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                _username(),
                _userBio(),
                _editProfileButton(),
                _tabButtons(),
              ]),
            )
          ],
        )
    );
  }

  Row _tabButtons() {
    return Row(
                children: <Widget>[
                  Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedLeft = true;
                          });
                        },
                        icon: ImageIcon(AssetImage('assets/images/grid.png'), color: selectedLeft? Colors.black : Colors.black26,),)
                  ),Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedLeft = false;
                          });
                        },
                        icon: ImageIcon(AssetImage('assets/images/saved.png'), color: selectedLeft? Colors.black26 : Colors.black,),)
                  ),

                ],
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
