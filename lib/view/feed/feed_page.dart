import 'package:flutter/material.dart';
import 'package:sharethought/styles/kcolor.dart';

import '../../model/post_model.dart';
import '../home/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      backgroundColor: Kcolor.white,
      appBar: AppBar(
        title: Text("Feed Page"), 
        elevation: 0.0,  
        backgroundColor: Kcolor.white,
        foregroundColor: Kcolor.baseBlack,
        actions: [
          CircleAvatar(
            radius: 30.0, 
            child: Image.asset("assets/images/profilepic.png"), 
          )
        ],
      ),
      body: ListView.builder(
      shrinkWrap: true,
      itemCount: PostModel.postList.length,
      itemBuilder: (context, index) {
        return PostCard(postList :PostModel.postList, index: index,);
      },
    ), 
    ); 
  }
}