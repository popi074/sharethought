import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sharethought/common_widget/common_app_bar.dart';
import 'package:sharethought/constants/shared_pref_data.dart';
import 'package:sharethought/core/controllers/auth/login_controller.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:sharethought/model/commnet_model.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ktext_style.dart';

import '../core/controllers/comment/comment_service.dart';
import '../model/post_model.dart';
import '../view/auth/userdata/user_data_provider.dart';
import 'get_time.dart';

class CommentSection extends StatefulWidget {
  final PostModel postModel;
  final UserModel userData;
  const CommentSection(
      {super.key, required this.postModel, required this.userData});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late CommentService commentService;
  TextEditingController textcon = TextEditingController();
  // late UserModel userData ;
  @override
  void initState() {
    super.initState();
    commentService = CommentService();
    // getUserData();
  }
  // getUserData()async{
  //   userData = await getuserData();
  // }

  @override
  Widget build(BuildContext context) {
    print(widget.postModel.postId);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CommonAppBar(title: "Comments"),
      body: Column(
        children: [
          // AllComments(),
          Expanded(
            child: Consumer(builder: (context, ref, _) {
              final comments =
                  ref.watch(commentProvider(widget.postModel.postId));
              print(comments.value);
              return comments.when(data: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text("emty data"));
                } else {
                  print("--insde ui data---");
                  print(data);
                  print("--insde ui data end-----");
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return CommentCard(
                          comment: data[index], userData: widget.userData);
                    },
                  );
                }
              }, error: (Object error, StackTrace stackTrace) {
                return const Center(child: Text("error"));
              }, loading: () {
                return const Center(child: Text("Loading..."));
              });
            }),
          ),
          // _buildTextField(),

          buildTextField(),
          // Column(
          //   children: [
          //     Divider(
          //       color: Kcolor.grey350,
          //     ),
          //     Row(
          //       children: [
          //         Expanded(
          //             child: Container(
          //           child: TextField(
          //             controller: textcon,
          //             maxLines: 3,
          //             decoration: InputDecoration(
          //                 contentPadding: EdgeInsets.only(left: 20),
          //                 border: const UnderlineInputBorder(
          //                     borderSide: BorderSide.none),
          //                 suffixIcon: InkWell(
          //                     onTap: () async {
          //                       if (textcon.text.isNotEmpty) {
          //                         print("comment model printed");
          //                         CommentModel commentModel = CommentModel(
          //                             '',
          //                             widget.userData.uid,
          //                             widget.postModel.postId ?? '',
          //                             widget.userData.photourl ?? '',
          //                             textcon.text,
          //                             widget.userData.username,
          //                             [],
          //                             DateTime.now());
          //                         final container = ProviderContainer();
          //                         final res = await commentService
          //                             .addComment(commentModel);
          //                         textcon.clear();
          //                       }
          //                     },
          //                     child: const Icon(
          //                       Icons.send_rounded,
          //                       color: Kcolor.secondary,
          //                     ))),
          //           ),
          //         ))
          //       ],
          //     ),
          //   ],
          // )
       
       
        ],
      ),
    );
  }

  Widget buildTextField(
     ) {
        final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
          left: width * .05, right: width * .05, top: 10.0, bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textcon,
              maxLines: 3,
              minLines: 1,
              style: ktextStyle.smallTextBold
                  .copyWith(color: Colors.black.withOpacity(.5)),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10, right: 10, top: 0, bottom: 0),
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25.0),
                  )),
            ),
          ),
          const SizedBox(width: 10),
          Consumer(builder: (context, ref, _) {
            return IconButton(
                onPressed: () async{
                 if (textcon.text.isNotEmpty) {
                                  print("comment model printed");
                                  CommentModel commentModel = CommentModel(
                                      '',
                                      widget.userData.uid,
                                      widget.postModel.postId ?? '',
                                      widget.userData.photourl ?? '',
                                      textcon.text,
                                      widget.userData.username,
                                      [],
                                      DateTime.now());
                                  final container = ProviderContainer();
                                  final res = await commentService
                                      .addComment(commentModel);
                                  textcon.clear();
                                }
                },
                icon: Icon(Icons.send));
          })
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Column(
      children: [
        Divider(
          color: Kcolor.grey350,
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              color: Colors.red,
              child: const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    suffixIcon: InkWell(
                        child: Icon(
                      Icons.send_rounded,
                      color: Kcolor.secondary,
                    ))),
              ),
            ))
          ],
        ),
      ],
    );
  }
}

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final UserModel userData;
  const CommentCard({super.key, required this.comment, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularNetworkProfile(userData: userData),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    // username
                    TextSpan(
                        text: "${comment.username} ",
                        style: ktextStyle.font20
                            .copyWith(color: Colors.black..withOpacity(.6))),
                    // comment text
                    TextSpan(
                        text: comment.text,
                        style: ktextStyle.font18
                            .copyWith(color: Colors.black..withOpacity(.6)))
                  ])),
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          // date time
                          Text(
                            comment.date == null
                                ? "dateTime "
                                : formatDateTime(comment.date!),
                            style: ktextStyle.smallText
                              ..copyWith(color: Colors.black..withOpacity(.6)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Likes ${comment.likes.length}",
                            style: ktextStyle.smallText
                              ..copyWith(color: Colors.black..withOpacity(.6)),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await CommentService().likeComment(comment, userData.uid);
              // if(!comment.likes.contains(userData.uid)){
              //   await CommentService().likeComment(comment, comment.likes,userData.uid);
              // }else{
              //   print("allready liked it");
              // }
            },
            icon: Icon(
              comment.likes.contains(userData.uid)
                  ? Icons.favorite
                  : Icons.favorite_outline_outlined,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class CircularNetworkProfile extends StatelessWidget {
  const CircularNetworkProfile({
    super.key,
    required this.userData,
  });

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    if(userData.photourl.isEmpty){
     return  CircleAvatar(
        radius: 18.0, 
        backgroundImage: AssetImage(DatabaseConst.personavater), 
        
      );
    }else{
      return CircleAvatar(
        radius: 18.0, 
        backgroundImage: NetworkImage(userData.photourl)
        
      );
    }
    return CircleAvatar(
      radius: 18.0,
      backgroundImage:    NetworkImage(userData.photourl),
      child: userData.photourl.isEmpty
          ? Image.asset(
              "assets/images/user.png",
              fit: BoxFit.contain,
            )
          : Image.network(
              userData.photourl,
              fit: BoxFit.contain,
            ),
      // child: Image.asset(
      //   "assets/images/profilepic.png",
      //   fit: BoxFit.contain,
      // ),
    );
  }
}
// class profilePicture extends StatelessWidget {
//   const profilePicture({
//     super.key,
//     required this.userStreamData,
//     required this.ref,
//     required this.userData,
//   });

//   final AsyncValue<UserModel> userStreamData;
//   final WidgetRef ref;
//   final UserModel userData;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       width: 100,
//       child: Stack(
//         children: [
//           Positioned(
//               left: 0,
//               right: 0,
//               top: 0,
//               bottom: 0,
//               child: userStreamData.asData!.value.photourl.isNotEmpty
//                   ? CircleAvatar(
//                       radius: 30.0,
//                       backgroundImage:
//                           NetworkImage(userStreamData.asData!.value.photourl),
//                       // backgroundColor: Colors.black,
//                     )
//                   : const CircleAvatar(
//                       radius: 30.0,
//                       backgroundImage: AssetImage(DatabaseConst.personavater),
//                       // backgroundColor: Colors.black,
//                     )),
//           Positioned(
//             bottom: 10,
//             right: 0,
//             child: InkWell(
//               onTap: () {
//                 ref
//                     .read(profileProvider.notifier)
//                     .updateProfile(userData.uid, userData.photourl);
//               },
//               child: Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(40),
//                     color: Kcolor.white),
//                 alignment: Alignment.center,
//                 child: const Icon(Icons.edit, size: 25),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }


