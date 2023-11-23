import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ktext_style.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
              onPressed: () {},
            )
          ],
        ),
        body: Padding( 
          padding: const EdgeInsets.only(left:15,right:15,top:10),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
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
        decoration: InputDecoration(
          hintStyle: ktextStyle.font24(Kcolor.grey),
          border: OutlineInputBorder(
           
            borderSide: BorderSide.none
          ),
          hintText: "Whats on your mind?",
        ),
        maxLines: null,
      ),
    );
  }
}
