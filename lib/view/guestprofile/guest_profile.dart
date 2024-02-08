import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sharethought/common_widget/button/k_button.dart';
import 'package:sharethought/common_widget/loading/k_circularloading.dart';
import 'package:sharethought/common_widget/post_list.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/core/controllers/auth/login_controller.dart';
import 'package:sharethought/core/controllers/profile/profile_controller.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ksize.dart';
import 'package:sharethought/styles/ktext_style.dart';
import 'package:sharethought/view/auth/login/login.dart';
import 'package:sharethought/view/auth/login/state.dart';
import 'package:sharethought/view/guestprofile/state.dart';
import 'package:sharethought/view/home/post_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../common_widget/button/k_elevated_btn.dart';
import '../../common_widget/custom_back_button.dart';
import '../../common_widget/dialog/k_confirm_dialog.dart';
import '../../common_widget/loading/k_post_shimmer.dart';
import '../../core/controllers/chat/chat_controller.dart';
import '../../core/controllers/guest/guest_controller.dart';
import '../../core/controllers/guest/guest_feed_steam.dart';
import '../../model/post_model.dart';
import '../../route/route_generator.dart';

class GuestProfile extends StatelessWidget {
  GuestProfile({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer(builder: (context, ref, _) {
        final userState = ref.watch(loginProvider);
        final userData =
            userState is LoginSuccessState ? userState.usermodel : null;
        final guestUserState = ref.watch(guestProvider);
        final guestUserData = guestUserState is GuestSuccessState
            ? guestUserState.GuestUserModel
            : null;
        if (guestUserState is LoadingState) {
          return const KcircularLoading();
        } else {
          if (guestUserData == null || userData == null) {
            // return const Center(
            //   child: Text("User not found"),
            // );
            return const KcircularLoading();
          } else {
            final guestStream = ref.watch(guestFeedStream(guestUserData!.uid));
            final guestUserStreamData =
                ref.watch(guestUserDataStream(guestUserData.uid));
            final chatState = ref.watch(chatProvider);

            print("guest data ${guestUserData.username}, id${guestUserData.uid}");
            print("userData data ${userData.username}, id${userData.uid}");
            return SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    guestUserStreamData.when(data: (data) {
                      print("guestprofile stream data ${data.photourl}");
                      return Column(
                        children: [
                          topProfileSection(
                              width,
                              context,
                              guestUserData.username,
                              data.isActive,
                               data.photourl
                             ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              numberAndText(number: "0", text: "post"),
                              numberAndText(
                                  number: guestUserStreamData.asData == null
                                      ? "wait"
                                      : guestUserStreamData
                                          .asData!.value.followers.length
                                          .toString(),
                                  text: "followers"),
                              numberAndText(
                                  number: guestUserStreamData.asData == null
                                      ? "wait"
                                      : guestUserStreamData
                                          .asData!.value.following.length
                                          .toString(),
                                  text: "following"),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: KelevatedButton(
                                      onPressed: () {
                                        if (guestUserStreamData
                                            .asData!.value.followers
                                            .contains(userData.uid)) {
                                          ref
                                              .read(guestProvider.notifier)
                                              .unFollow(guestUserData.uid,
                                                  userData.uid);
                                        } else {
                                          ref
                                              .read(guestProvider.notifier)
                                              .follow(guestUserData.uid,
                                                  userData.uid);
                                        }
                                      },
                                      text: guestUserStreamData.asData == null
                                          ? "wait"
                                          : guestUserStreamData
                                                  .asData!.value.followers
                                                  .contains(userData!.uid)
                                              ? "unfollow"
                                              : "follow"),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: KelevatedButton(
                                      onPressed: () {
                                        ref
                                            .read(chatProvider.notifier)
                                            .createChatIfNotExist(
                                                otherUserId: guestUserData.uid,
                                               
                                                guestUserData: guestUserData, userData: userData,);
                                      },
                                      text: "message"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      );
                    }, loading: () {
                      return const KcircularLoading();
                    }, error: (e, s) {
                      return const KcircularLoading();
                    }),

                    // PostList(postList: PostModel.postList, width: width)
                    // PostList(postList: postList, width: width)
                    guestStream.when(data: (allPost) {
                      if (allPost.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            "No Post Here!",
                            style: ktextStyle.font20
                              ..copyWith(color: Colors.black..withOpacity(.7)),
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allPost.length,
                        itemBuilder: (context, index) {
                          return PostCard(
                            postModelData: allPost[index],
                            index: index,
                            userData: guestUserData,
                            isProfilePage: true,
                          );
                          // return PostCard(postModelData:postDataList[index] ,index:index);
                        },
                      );
                    }, error: (e, stractace) {
                      return const KcircularLoading();
                    }, loading: () {
                      return const KcircularLoading();
                    })
                  ],
                ),
              ),
            );
          }
        }
      }),
    );
  }

  Column numberAndText({required String number, required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          number,
          style: ktextStyle.smallText
            ..copyWith(color: Colors.black..withOpacity(.5)),
        ),
        SizedBox(height: 10),
        Text(
          text,
          style: ktextStyle.smallText
            ..copyWith(color: Colors.black..withOpacity(.5)),
        )
      ],
    );
  }

  Widget topProfileSection(double width, BuildContext context, String username,
      bool isActive, String profileUrl) {
    return SizedBox(
      width: width,
      height: Ksize.getHeight(context, width * .2),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          menuIcon(),
          profilePicture(username, isActive, profileUrl),
        ],
      ),
    );
  }

  Widget menuIcon() {
    return Positioned(
      top: 40.0, // Adjust the position based on your layout
      right: 10.0,
      child: IconButton(
        icon: const Icon(Icons.menu, size: 30, color: Kcolor.baseBlack),
        onPressed: () {
          // Open the drawer
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
    );
  }

  Widget profileCover() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(color: Kcolor.secondary),
    );
  }

  Widget profilePicture(String username, bool isActive, String profileUrl) {
    return Positioned(
      top: 30,
      left: 10,
      child: Row(
        children: [

          Container(
         
            
            child: profileUrl.isEmpty? const CircleAvatar(radius: 40,backgroundImage:AssetImage(DatabaseConst.personavater))
            : CircleAvatar(radius: 40,backgroundImage: NetworkImage(profileUrl),)
          ),  
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: ktextStyle.mediumText
                  ..copyWith(color: Colors.black..withOpacity(.9)),
              ),
              const SizedBox(height: 10),
              Text(
                isActive ? "Online" : "Offline",
                style: ktextStyle.mediumText
                  ..copyWith(color: Colors.black..withOpacity(.9)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
