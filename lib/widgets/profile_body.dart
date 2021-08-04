import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/common_size.dart';
import 'package:make_feed_screen/constants/screen_size.dart';
import 'package:make_feed_screen/models/firestore/user_model.dart';
import 'package:make_feed_screen/models/firestore/user_model_state.dart';
import 'package:make_feed_screen/repo/user_network_repository.dart';
import 'package:make_feed_screen/screens/profile_screen.dart';
import 'package:make_feed_screen/widgets/rounded_profile.dart';
import 'package:provider/provider.dart';


enum SelectedTab {left, right}


class ProfileBody extends StatefulWidget {

  final Function onMenuChanged;

  const ProfileBody({Key? key, required this.onMenuChanged}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> with SingleTickerProviderStateMixin{
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesPageMargin = 0;
  double _rightImagesPageMargin = size!.width;
  
  AnimationController? _iconAnimationController;

  @override
  void initState() {
    _iconAnimationController = AnimationController(vsync: this, duration: icon_duration);
    super.initState();
  }
  
  @override
  void dispose() {
    _iconAnimationController!.dispose();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer<UserModelState>(
          builder: (context, userModelState, child) {
            return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _appbar(userName: userModelState.userModel!.username),
                  Expanded(
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverList(delegate: SliverChildListDelegate(
                            [
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(common_padding_h),
                                    child: RoundedProfile(size: 80,),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: common_padding_h),
                                      child: Table(
                                        children: [
                                          TableRow(
                                              children: [
                                                _valueText(userModelState.userModel!.myPosts.length.toString()),
                                                _valueText(userModelState.userModel!.followers.toString()),
                                                _valueText(userModelState.userModel!.followings.length.toString()),
                                              ]
                                          ),
                                          TableRow(
                                              children: [
                                                _labelText('게시물'),
                                                _labelText('팔로워'),
                                                _labelText('팔로잉'),
                                              ]
                                          ),
                                        ],),
                                    ),
                                  )
                                ],
                              ),
                              _username(userModelState.userModel!.username),
                              _userBio(),
                              _editProfileButton(),
                              _tabButtons(),
                              _selectedIndicator(),
                            ]
                        )),
                        _imagesPager(),
                      ],
                    ),
                  ),]
            );
        },)
    );

  }

  Widget _appbar({String? userName}) {
    if (userName != null) {
      return Row(
        children: <Widget>[
          SizedBox(width: 44,
              child: IconButton(
                  onPressed: () {}, icon: Icon(Icons.arrow_back))),
          Expanded(
              child: Text(
                userName,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
          ),
          IconButton(
              onPressed: () {
                widget.onMenuChanged();
                _iconAnimationController!.status == AnimationStatus.completed
                    ? _iconAnimationController!.reverse()
                    : _iconAnimationController!.forward();
              },
              icon: AnimatedIcon(icon: AnimatedIcons.menu_close,
                progress: _iconAnimationController!,)),
        ],
      );
    }
    else
      return TextButton.icon(onPressed: (){}, icon: Icon(Icons.error_outline), label: Text('user name is null.'));
  }

  Text _valueText(String value) => Text(value, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),);
  Text _labelText(String label) => Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w300),);

  SliverToBoxAdapter _imagesPager() {
    return SliverToBoxAdapter(
          child: Stack(
            children: [
              AnimatedContainer(
                duration: duration,
                transform: Matrix4.translationValues(_leftImagesPageMargin, 0, 0),
                curve: Curves.fastOutSlowIn,
                child: GridView.count(
                  crossAxisCount: 3,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  childAspectRatio: 1,
                  children: List.generate(common_show_images_num, (index) => CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: 'https://picsum.photos/id/$index/100/100')),
                ),
              ),
              AnimatedContainer(
                duration: duration,
                transform: Matrix4.translationValues(_rightImagesPageMargin, 0, 0),
                curve: Curves.fastOutSlowIn,
                child: GridView.count(
                  crossAxisCount: 3,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  childAspectRatio: 1,
                  children: List.generate(30, (index) => CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: 'https://picsum.photos/id/${index+30}/100/100')),
                ),
              )
            ],
          ),
        );
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
        duration: duration,
        child: Container(
          height: 3,
          color: Colors.black87,
          width: size!.width / 2,
        ),
        alignment: _selectedTab == SelectedTab.left? Alignment.centerLeft : Alignment.centerRight,
        curve: Curves.fastOutSlowIn,

    );
  }

  _tabSelected (SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _selectedTab = SelectedTab.left;
          _leftImagesPageMargin = 0;
          _rightImagesPageMargin = size!.width;
          break;

        case SelectedTab.right:
          _selectedTab = SelectedTab.right;
          _leftImagesPageMargin = -size!.width;
          _rightImagesPageMargin = 0;
          break;
      }
    });
  }

  Row _tabButtons() {
    return Row(
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          _tabSelected(SelectedTab.left);
                        },
                        icon: ImageIcon(
                            AssetImage('assets/images/grid.png'),
                          color: _selectedTab == SelectedTab.left? Colors.black : Colors.black26,
                        )),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          _tabSelected(SelectedTab.right);
                        },
                        icon: ImageIcon(
                          AssetImage('assets/images/saved.png'),
                          color: _selectedTab == SelectedTab.right? Colors.black : Colors.black26,
                        )),
                  ),
                ],
              );
  }

  Padding _editProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_padding_h, vertical: common_padding_v),
      child: SizedBox(
        height: 36,
        child: OutlineButton(
          onPressed: (){},
          borderSide: BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(common_radius),
          ),
          child: Text(
            'Edit Profile', style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _username(String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_padding_h),
      child: Text(
        // Provider.of<UserModelState>(context).userModel.username,
        userName,
        style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }

  Widget _userBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_padding_h),
      child: Text(
        'user profile introduction.',
        style: TextStyle(fontWeight: FontWeight.w400),),
    );
  }
}
