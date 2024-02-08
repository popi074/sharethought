import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/core/controllers/create_post/create_post_controller.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ktext_style.dart';
import 'package:sharethought/view/createPost/state.dart';

import '../../common_widget/loading/loading_text_btn.dart';

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
      print("result not null ${result}");
      setState(() {
        _selectedImages = result;
      });
    }
    print(_selectedImages);
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
    return Consumer(builder: (context, ref, _) {
      final postProvider = ref.watch(createPostProvider);
      if (postProvider is CreatePostSuccessState) {
        _selectedImages.clear();
        postTextCon.clear();
        //  ref.read(createPostProvider.notifier).resetState();
      }

      return Scaffold(
          backgroundColor: Kcolor.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Kcolor.white,
            foregroundColor: Kcolor.baseBlack,
            title: Text(
              "Create Post",
              style: ktextStyle.font18
                ..copyWith(color: Colors.black..withOpacity(.5)),
            ),
            actions: [
              postButtom(postProvider, ref, () async {
                print("button pressed");
                if (postProvider is! LoadingState) {
                  print("button pressed if");
                  await ref
                      .read(createPostProvider.notifier)
                      .createNewPost("post", _selectedImages, postTextCon.text);
                }
                if (postProvider is CreatePostSuccessState) {
                  ref.read(createPostProvider.notifier).resetState();
                }
              })
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
    });
  }

  Widget postButtom(
      BaseState postProvider, WidgetRef ref, VoidCallback onPressed) {
    // return Container(
    //     padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(2),
    //       color: const Color.fromARGB(255, 206, 199, 203),
    //     ),
    //     child: postProvider is LoadingState
    //         ? const CircularProgressIndicator()
    //         : TextButton(
    //             child: Text(
    //               "post",
    //               style: ktextStyle.font20(Kcolor.black),
    //             ),
    //             onPressed: () async {
    //               await ref
    //                   .read(createPostProvider.notifier)
    //                   .createNewPost("post", _selectedImages, postTextCon.text);
    //               ref.read(createPostProvider.notifier).resetState();
    //             },
    //           ));

    return TextButton(
        onPressed: onPressed,
        child: Container(
          width: 100,
          height: 80,
          decoration: BoxDecoration(
            color: Kcolor.secondary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          alignment: Alignment.center,
          child: (postProvider is LoadingState)
              ? const LoadingTextBtn()
              : Text(
                  "post",
                  style: ktextStyle.buttonText20.copyWith(color:Colors.white),
                ),
        ));
  }

  Widget profilePicAndNameRow() {
    return ListTile(
      leading: CircleAvatar(
          radius: 30.0, child: Image.asset("assets/images/profilepic.png")),
      title: Text(
        "Shinna",
        style: ktextStyle.font20
          ..copyWith()
          ..copyWith(color: Colors.black..withOpacity(.5)),
      ),
    );
  }

  Widget kUploadIcon() {
    return InkWell(
      onTap: () {
        print("upload pic tapped");
        pickImage();
      },
      child: Row(
        children: [
          Text(
            "upload picture",
            style: ktextStyle.font18..copyWith(color: Colors.black),
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
    print("image grid view $_selectedImages");
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: _selectedImages.length,
        (context, index) {
          print("all the selected image");
          print(_selectedImages);
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
          hintStyle: ktextStyle.font24
            ..copyWith(color: Colors.grey..withOpacity(1)),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          hintText: "Whats on your mind?",
        ),
        maxLines: null,
      ),
    );
  }
}
