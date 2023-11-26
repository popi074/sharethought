import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharethought/model/post_model.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ktext_style.dart';

import '../view/home/post_card.dart';

class PostList extends StatefulWidget {
  const PostList({
    super.key,
    required this.postList,
    required this.width,
  });

  final List<Map<String, String>> postList;
  final double width;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    print("outoput is");
    print(widget.postList.length);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.postList.length,
      itemBuilder: (context, index) {
        return PostCard(postList: PostModel.postList,index:index);
      },
    );
  }
}

