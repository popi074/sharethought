import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharethought/common_widget/loading/k_circularloading.dart';
import 'package:sharethought/common_widget/post_list.dart';
import 'package:sharethought/constants/shared_pref_data.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/core/controllers/auth/login_controller.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';
import 'package:sharethought/core/controllers/profile/profile_controller.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:sharethought/services/navigator_service.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ksize.dart';
import 'package:sharethought/styles/ktext_style.dart';
import 'package:sharethought/view/auth/login/login.dart';
import 'package:sharethought/view/auth/login/state.dart';
import 'package:sharethought/view/auth/userdata/user_data_provider.dart';
import 'package:sharethought/view/home/post_card.dart';

import '../../common_widget/custom_back_button.dart';
import '../../common_widget/dialog/k_confirm_dialog.dart';
import '../../common_widget/loading/k_post_shimmer.dart';
import '../../model/post_model.dart';
import '../../route/route_generator.dart';

class Profile_Page extends StatefulWidget {
  Profile_Page({super.key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? _selectedImage;
  String authUserId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  getUserId() async {
    authUserId = await SharedPrefData().getUserId();
    print("userid in sharedpref");
    print(authUserId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Kcolor.white,
      key: _scaffoldKey,
      body: Consumer(builder: (context, ref, _) {
        final profileState = ref.watch(profileProvider);
        final userState = ref.watch(loginProvider);
        final userData =
            userState is LoginSuccessState ? userState.usermodel : null;
        if (userData == null) {
          return KcircularLoading();
        } else {
          final userPostStream = ref.watch(profileStreamProvider(userData.uid));
          final userStreamData = ref.watch(userStream(userData.uid));
          return SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  // topProfileSection(width, context, userData.username,
                  //     userData.isActive, userData.photourl),
                  userStreamData.when(data: (data) {
                    return ProfileHeader(
                      width: width,
                      scaffoldKey: _scaffoldKey,
                      userStreamData: userStreamData,
                      userData: userData,
                      ref: ref,
                    );
                  }, loading: () {
                    return KcircularLoading();
                  }, error: (e, s) {
                    return const KcircularLoading();
                  }),
                  SizedBox(
                    height: 50,
                  ),
                  userPostStream.when(data: (allPost) {
                    if (allPost.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Text(
                          "No Post Here!",
                          style: ktextStyle.font20
                            ..copyWith(color: Colors.black..withOpacity(.5)),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allPost.length,
                        itemBuilder: (context, index) {
                          return PostCard(
                            postModelData: allPost[index],
                            index: index,
                            userData: userData,
                            isProfilePage: true,
                          );
                          // return PostCard(postModelData:postDataList[index] ,index:index);
                        },
                      );
                    }
                  }, error: (e, stractace) {
                    return Center(
                      child: Text("user posts $e"),
                    );
                  }, loading: () {
                    return const KcircularLoading();
                  })
                ],
              ),
            ),
          );
        }
      }),
      // drawer: MyDrawer(),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(
      {super.key,
      required this.width,
      required GlobalKey<ScaffoldState> scaffoldKey,
      required this.userStreamData,
      required this.userData,
      required this.ref})
      : _scaffoldKey = scaffoldKey;

  final double width;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final AsyncValue<UserModel> userStreamData;
  final UserModel userData;
  final WidgetRef ref;

  ListTile listTile(
      {required Icon icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: icon,
      title: Text(text),
      onTap: onTap,
    );
  }

  void _showListPopup(BuildContext context, String username, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Menus'),
          content: Container(
            width: MediaQuery.of(context).size.width * .7,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                // listTile(
                //     icon: Icon(Icons.settings), text: "Setting", onTap: () {}),
                // listTile(
                //     icon: Icon(Icons.email_outlined),
                //     text: "Email",
                //     onTap: () {
                //       Navigator.pushNamed(context, RouteGenerator.addEmail, arguments: {"username":username, "userid":userId});
                //     }),
                Consumer(builder: (context, ref, _) {
                  return listTile(
                    icon: Icon(Icons.settings),
                    text: "Logout",
                    onTap: () async {
                      Navigator.of(context).pop();
                      print("ontap logout");
                      await SharedPrefData().removeDataFromSharedPreferences(
                          SharedPrefData.USERID);
                      await SharedPrefData().removeDataFromSharedPreferences(
                          DatabaseConst.isLoggedIn);

                      // await NavigatorService.navigateToRouteName(RouteGenerator.login);
                       NavigatorService.navigateAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                                Login()), // Replace with your login page route
                      );
                      // await ref.read(loginProvider.notifier).logout();
                      // KConfirmDialog(
                      //   message: "Are you sure?",
                      //   subMessage: "this is sub message",
                      //   onCancel: () {
                      //     Navigator.of(context)
                      //         .pop(); // Make sure the context is correct here
                      //   },
                      //   onDelete: () async {
                      //     await ref.read(loginProvider.notifier).logout();
                      //   },
                      // );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width,
          height: Ksize.getHeight(context, width * .2),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 40.0, // Adjust the position based on your layout
                right: 10.0,
                child: IconButton(
                  icon:
                      const Icon(Icons.menu, size: 30, color: Kcolor.baseBlack),
                  onPressed: () {
                    // Open the drawer
                    // _scaffoldKey.currentState?.openDrawer();
                    _showListPopup(context, userData.username, userData.uid);
                  },
                ),
              ),
              // profilePicture(username, isActive, profileUrl),
              Positioned(
                top: 30,
                left: 10,
                child: Row(
                  children: [
                    profilePicture(
                        userStreamData: userStreamData,
                        ref: ref,
                        userData: userData),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData.username,
                          style: ktextStyle.mediumText
                            ..copyWith(color: Colors.black..withOpacity(.5)),
                        ),
                        const SizedBox(height: 10),
                        // Text(
                        //   userData.isActive ? "Online" : "Offline",
                        //   style: ktextStyle.mediumText
                        //     ..copyWith(color: Colors.black..withOpacity(.5)),
                        // ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            numberAndText(number: "0", text: "post"),
            numberAndText(
                number:
                    userStreamData.asData!.value.followers.length.toString(),
                text: "followers"),
            numberAndText(
                number:
                    userStreamData.asData!.value.following.length.toString(),
                text: "follow"),
          ],
        ),
      ],
    );
  }

  Widget numberAndText({required String number, required String text}) {
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
}

class profilePicture extends StatelessWidget {
  const profilePicture({
    super.key,
    required this.userStreamData,
    required this.ref,
    required this.userData,
  });

  final AsyncValue<UserModel> userStreamData;
  final WidgetRef ref;
  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: userStreamData.asData!.value.photourl.isNotEmpty
                  ? CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                          NetworkImage(userStreamData.asData!.value.photourl),
                      // backgroundColor: Colors.black,
                    )
                  : const CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage(DatabaseConst.personavater),
                      // backgroundColor: Colors.black,
                    )),
          Positioned(
            bottom: 10,
            right: 0,
            child: InkWell(
              onTap: () {
                ref
                    .read(profileProvider.notifier)
                    .updateProfile(userData.uid, userData.photourl);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Kcolor.white),
                alignment: Alignment.center,
                child: const Icon(Icons.edit, size: 25),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            listTile(icon: Icon(Icons.settings), text: "Setting", onTap: () {}),
            listTile(
                icon: Icon(Icons.email_outlined),
                text: "Email",
                onTap: () {
                  Navigator.pushNamed(context, RouteGenerator.addEmail);
                }),
            Consumer(builder: (context, ref, _) {
              return listTile(
                icon: Icon(Icons.settings),
                text: "Logout",
                onTap: () async {
                  Navigator.of(context).pop();
                  print("ontap logout");
                  await ref.read(loginProvider.notifier).logout();
                  // KConfirmDialog(
                  //   message: "Are you sure?",
                  //   subMessage: "this is sub message",
                  //   onCancel: () {
                  //     Navigator.of(context)
                  //         .pop(); // Make sure the context is correct here
                  //   },
                  //   onDelete: () async {
                  //     await ref.read(loginProvider.notifier).logout();
                  //   },
                  // );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  ListTile listTile(
      {required Icon icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: icon,
      title: Text(text),
      onTap: onTap,
    );
  }
}
