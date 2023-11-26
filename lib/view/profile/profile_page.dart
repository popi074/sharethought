import 'package:flutter/material.dart';
import 'package:sharethought/common_widget/post_list.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ksize.dart';
import 'package:sharethought/styles/ktext_style.dart';

import '../../common_widget/custom_back_button.dart';
import '../../model/post_model.dart';
import '../../route/route_generator.dart';

class Profile_Page extends StatelessWidget {

  Profile_Page({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics:const ScrollPhysics(),
          child: Column(
            children: [
              topProfileSection(width, context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  numberAndText(number: "0", text: "post"),
                  numberAndText(number: "0", text: "followers"),
                  numberAndText(number: "0", text: "follow"),
                ],
              ),
              PostList(postList: PostModel.postList, width: width)
              // PostList(postList: postList, width: width)
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }

  Column numberAndText({required String number, required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          number,
          style: ktextStyle.smallText(Kcolor.baseBlack),
        ),
        SizedBox(height: 10),
        Text(
          text,
          style: ktextStyle.smallText(Kcolor.baseBlack),
        )
      ],
    );
  }

  Widget topProfileSection(double width, BuildContext context) {
    return SizedBox(
      width: width,
      height: Ksize.getHeight(context, width * .2),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          menuIcon(),
          profilePicture(),
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

  Widget profilePicture() {
    return Positioned(
      top: 30,
      left: 10,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Kcolor.baseBlack),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Username",
                style: ktextStyle.mediumText(Kcolor.blackbg),
              ),
              const SizedBox(height: 10),
              Text(
                "online",
                style: ktextStyle.mediumText(Kcolor.black),
              ),
            ],
          )
        ],
      ),
    );
  }
}
// comment section 


class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            listTile(icon : Icon(Icons.settings), text: "Setting", onTap: (){}),
            listTile(icon: Icon(Icons.email_outlined), text: "Email"  , onTap: (){
              Navigator.pushNamed(context, RouteGenerator.addEmail);
            }
            ),
          ],
        ),
      ),
    );
  }

  ListTile listTile({required Icon icon,required String text,required VoidCallback onTap}) {
    return ListTile(
      leading: icon,
      title: Text(text),
      onTap: onTap,
    );
  }
}
