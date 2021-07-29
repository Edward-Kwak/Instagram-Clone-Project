import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_split/constants/common_vars.dart';

enum SelectedTab {left, right}

class ProfileBody extends StatefulWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {

  final double selectionBarHeight = 3;
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftPageMargin = 0;
  double _rightPageMargin = size!.width;
  // bool selectedLeft = true;


  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                _username(),
                _userBio(),
                _editProfileButton(),
                _tabButtons(),
                _selectedIndicator(),
              ]),
            ),
            _imagesPager()
          ],
        )
    );
  }

  SliverToBoxAdapter _imagesPager() {
    return SliverToBoxAdapter(
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: common_animation_duration,
                  transform: Matrix4.translationValues(_leftPageMargin, 0, 0),
                  curve: Curves.fastOutSlowIn,
                  child: GridView.count (
                    crossAxisCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 1,
                    children: List.generate(30, (index) => CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: 'https://picsum.photos/id/$index/200/200')),
                  ),
                ),
                AnimatedContainer(
                  duration: common_animation_duration,
                  transform: Matrix4.translationValues(_rightPageMargin, 0, 0),
                  curve: Curves.fastOutSlowIn,
                  child: GridView.count (
                    crossAxisCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 1,
                    children: List.generate(30, (index) => CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: 'https://picsum.photos/id/${index+30}/200/200')),
                  ),
                ),
              ]
            ),
          );
  }

  Row _tabButtons() {
    return Row(
                children: <Widget>[
                  Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedTab = SelectedTab.left;
                            _leftPageMargin = 0;
                            _rightPageMargin = size!.width;
                          });
                        },
                        icon: ImageIcon(
                          AssetImage('assets/images/grid.png'),
                          color: _selectedTab == SelectedTab.left ? Colors.black : Colors.black26,
                        ),
                      )
                  ),
                  Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedTab = SelectedTab.right;
                            _leftPageMargin = -size!.width;
                            _rightPageMargin = 0;
                          });
                        },
                        icon: ImageIcon(
                          AssetImage('assets/images/saved.png'),
                          color: _selectedTab == SelectedTab.right ? Colors.black26 : Colors.black,
                        ),
                      )
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

  AnimatedContainer _selectedIndicator() {
    return AnimatedContainer(
      duration: common_animation_duration,
      child: Container(
        height: selectionBarHeight,
        width: size!.width/2,
        color: Colors.grey,
      ),
      alignment: _selectedTab == SelectedTab.left ? Alignment.centerLeft : Alignment.centerRight,
      curve: Curves.fastOutSlowIn,
    );
  }

}
