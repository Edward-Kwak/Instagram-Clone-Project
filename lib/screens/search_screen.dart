import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/common_size.dart';
import 'package:make_feed_screen/models/firestore/user_model.dart';
import 'package:make_feed_screen/models/firestore/user_model_state.dart';
import 'package:make_feed_screen/repo/user_network_repository.dart';
import 'package:make_feed_screen/widgets/my_progress_indicator.dart';
import 'package:make_feed_screen/widgets/rounded_profile.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // List<bool> followings = List.generate(common_show_images_num, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Follow / UnFollow'), centerTitle: true,),
      body: StreamBuilder<List<UserModel>>(
        stream: userNetworkRepository.getAllUsersWithoutMe(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return SafeArea(
                child: Consumer<UserModelState>(
                  builder: (context, myUserModelState, child) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        UserModel otherUser = snapshot.data!.elementAt(index);
                        bool amIFollowing = myUserModelState.amIFollowingThisUser(otherUser.userKey);
                        return ListTile(
                          onTap: () {
                            setState(() {
                              amIFollowing ?
                              userNetworkRepository.unfollowUser(myUserModelState.userModel!.userKey, otherUser.userKey)
                                  : userNetworkRepository.followUser(myUserModelState.userModel!.userKey, otherUser.userKey);
                            });
                          },
                          leading: RoundedProfile(),
                          // title: Text('user$index'),
                          title: Text(otherUser.username),
                          subtitle: Text('this is ${otherUser.username}\'s bio.'),
                          trailing: Container(
                            width: 80,
                            height: 30,
                            decoration: BoxDecoration(
                              // color: followings[index] ? Colors.red[50] : Colors.blue[50],
                              color: amIFollowing ? Colors.red[50] : Colors.blue[50],
                              border: Border.all(
                                // color: followings[index] ? Colors.red : Colors.blue,
                                  color: amIFollowing ? Colors.red : Colors.blue,
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(common_radius),),
                            child: FittedBox(
                              child: Text(
                                amIFollowing?'Unfollow 하기':'Follow 하기',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,),
                            ),
                            alignment: Alignment.center,
                          ),);
                      },
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.grey,);
                      },
                      itemCount: snapshot.data!.length,
                    );
                  },
                )
            );
          }
          else return MyProgressIndicator();
        }
      ),
    );
  }
}
