import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/common_size.dart';
import 'package:make_feed_screen/models/firestore/comment_model.dart';
import 'package:make_feed_screen/models/firestore/user_model.dart';
import 'package:make_feed_screen/models/firestore/user_model_state.dart';
import 'package:make_feed_screen/repo/comment_network_repository.dart';
import 'package:make_feed_screen/widgets/comment.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  
  final String postKey;
  
  const CommentsScreen(this.postKey, {Key? key}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {

  TextEditingController _textEditingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Comments'), centerTitle: true,),
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                    child: StreamProvider<List<CommentModel>>.value(
                        initialData: [],
                        value: commentNetworkRepository.fetchAllComments(widget.postKey),
                        child: Consumer<List<CommentModel>>(
                          builder: (context, comments, child) {
                            return ListView.separated(
                                reverse: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(common_padding_h),
                                    child: Comment(
                                      userName: comments[index].userName,
                                      text: comments[index].comment,
                                      dateTime: comments[index].commentTime,
                                      showProfileImg: true,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: common_padding_v_s,);
                                },
                                itemCount: comments == null ? 0 : comments.length,
                            );
                          },
                        ),
                    )
                ),
                Divider(height: 1,thickness: 1,color: Colors.grey[400],),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: common_padding_h),
                          child: TextFormField(
                            controller: _textEditingController,
                            cursorColor: Colors.black54,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Leave a comment..',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if(value!.isEmpty)
                                return 'Please Input Comment';
                              else
                                return null;
                            },
                          ),
                        )
                    ),
                    FlatButton(
                        onPressed: () async {
                          if(_formKey.currentState!.validate()) {
                            UserModel? userModel = Provider.of<UserModelState>(context, listen: false).userModel;
                            Map<String, dynamic> newComment = CommentModel.getMapForNewComment(userModel!.userKey, userModel.username, _textEditingController.text);
                            await commentNetworkRepository.createNewComment(widget.postKey, newComment);
                            _textEditingController.clear();
                          }
                        },
                        child: Text('Post', style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                  ],
                )
              ],
            )
        )
    );
  }
}
