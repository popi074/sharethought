import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharethought/core/controllers/create_post/create_post_controller.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ktext_style.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {

  TextEditingController postTextCon = TextEditingController(); 
  List<XFile> _selectedImages = [];

  Future<void> pickImage() async {
    final List<XFile>? result = await ImagePicker().pickMultiImage();
    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedImages = result;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postTextCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer(
      builder: (context, ref,_) {
        final postProvider = ref.watch(createPostProvider);
        return Scaffold(
            backgroundColor: Kcolor.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Kcolor.white,
              foregroundColor: Kcolor.baseBlack,
              title: Text(
                "Create Post",
                style: ktextStyle.font18(Kcolor.black),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "post",
                    style: ktextStyle.font20(Kcolor.black),
                  ),
                  onPressed: () {
                    ref.read(createPostProvider.notifier).createNewPost("post", _selectedImages,postTextCon.text );
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      profilePicAndNameRow(),
                      _buildTextField(width, height),
                      const SizedBox(height: 20),
                      kUploadIcon(),
                    ]),
                  ),
                  imgeGridViewList()
                ],
              ),
            ));
      }
    );
  }

  Widget profilePicAndNameRow() {
    return ListTile(
      leading: CircleAvatar(
          radius: 30.0, child: Image.asset("assets/images/profilepic.png")),
      title: Text(
        "Shinna",
        style: ktextStyle.font20(Kcolor.baseBlack),
      ),
    );
  }

  Widget kUploadIcon() {
    return InkWell(
      onTap: () {
        pickImage();
      },
      child: Row(
        children: [
          Text(
            "upload picture",
            style: ktextStyle.font18(Kcolor.black),
          ),
          IconButton(
            icon: const Icon(Icons.upload_file_outlined, size: 20),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget imgeGridViewList() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: _selectedImages.length,
        (context, index) {
          return Image.file(File(_selectedImages[index].path),
              fit: BoxFit.cover);
        },
      ),
    );
  }

  Widget _buildTextField(double width, double height) {
    return Container(
      width: width, // Set the width of the TextField container
      child: TextField(
        controller: postTextCon,
        decoration: InputDecoration(
          hintStyle: ktextStyle.font24(Kcolor.grey),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          hintText: "Whats on your mind?",
        ),
        maxLines: null,
      ),
    );
  }
}
